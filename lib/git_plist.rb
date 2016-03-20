require "git_plist/version"
require "json"
require "open3"

# These monkey-patches are to avoid spurious diffs caused by non-semantically-significant ordering
# differences -- specifically in maps.  However, to keep it simple we just ensure `canonicalize` can
# be safely called on (pretty-much) *anything*.
#
# rubocop:disable Style/Documentation
class Object; def canonicalize; self; end; end
class NilClass; def canonicalize; self; end; end
class TrueClass; def canonicalize; self; end; end
class FalseClass; def canonicalize; self; end; end
class Array; def canonicalize; map(&:canonicalize); end; end

class Hash
  def canonicalize
    Hash[
      to_a
      .map { |key, value| [key.canonicalize, value.canonicalize] }
      .sort
    ]
  end
end
# rubocop:enable Style/Documentation

# Git diff filter for OS X `*.plist` files.
module GitPlist
  JSON_MARKER   = "{".freeze
  XML_MARKER    = "<?xm".freeze
  PLIST_FORMATS = [:xml1, :binary1, :json].freeze

  def self.convert(data, format)
    out, _err, status = Open3.capture3("plutil -convert #{format} - -s -o -",
                                       stdin_data: data,
                                       binmode:    true)
    return nil unless status.success?
    out
  end

  def self.string_from_unknown(result); result["data"].map(&:chr).join(""); end
  def self.unknown_from_string(data); data.bytes.map(&:ord); end

  def self.data_from(result)
    case result["new_format"]
    when "xml1" then  result["data"].join("\n")
    when "json" then  JSON.generate(result["data"])
    else              string_from_unknown(result)
    end
  end

  def self.clean(data)
    original_format = GitPlist.format_of(data)

    return data if original_format == :unknown

    result = { original_format: original_format }.merge(GitPlist.normalize_to_json(data))

    "#{JSON.pretty_generate(result)}\n"
  end

  def self.smudge(raw)
    # If we get a zero-length input, or non-JSON input, don't try to be clever, just pass it through
    # and hope for the best.
    return raw if raw.empty? || !json?(raw)

    result = JSON.parse(raw)
    raise "Parse error, expected a JSON hash, got: #{result.class}" unless result.is_a?(Hash)

    data              = data_from(result)
    fmt               = result["original_format"]

    convert(data.force_encoding("ASCII-8BIT"), fmt) || string_from_unknown(result)
  end

  def self.normalize_to_json(data)
    # Try to convert to JSON, if possible.  This produces the cleanest/easiest to review diffs.
    out = convert(data, "json")
    return enclose(:json, JSON.parse(out).canonicalize) if out

    # Must have a binary blob or date value, because it don't wanna give us JSON.  Boo!  Try XML,
    # which we'll split on line breaks to keep diffs relatively readable.
    out = convert(data, "xml1")
    return enclose(:xml1, out.rstrip.split(/\n/)) if out

    # Whatever the hell we have, `plutil` does NOT like it...
    enclose(:unknown, unknown_from_string(data))
  end

  def self.enclose(new_format, new_data); { new_format: new_format, data: new_data }; end

  def self.format_of(data)
    magic_word = !data.empty? ? data[0..3] : ""
    case
    when magic_word == "bpli" then :binary1 # TODO: What happens if they make a v2 of the format?
    when xml?(magic_word)     then :xml1 # TODO: What happens if they make a v2 of the format?
    when json?(magic_word)    then :json
    else                           :unknown
    end
  end

  def self.json?(prefix); prefix[0] == JSON_MARKER; end
  def self.xml?(prefix); prefix[0..3] == XML_MARKER; end
end
