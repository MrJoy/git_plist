require "git_plist/version"
require "shellwords"
require "json"
require "tempfile"

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
  JSON_MARKERS  = ["{", "["].freeze
  XML_MARKER    = "<?xm".freeze
  PLIST_FORMATS = [:xml1, :binary1, :json].freeze

  def self.convert_to_json(data, original_format)
    file_out = Tempfile.new("plist_clean_out")
    begin
      file_out.write(data)
      file_out.flush

      # Passing gibberish through as-is...
      return enclose(:unknown, data.bytes.map(&:ord)) unless PLIST_FORMATS.include?(original_format)

      # TODO: Use POpen3 or some such and stream the data in, rather than using a temp file.
      out_fname   = Shellwords.shellescape(file_out.path)
      new_data    = `plutil -convert json #{out_fname} -s -o -`.lstrip
      return enclose(:json, JSON.parse(new_data).canonicalize) if is_json?(new_data)

      # Must have a binary blob or date value, because it don't wanna give us JSON.  Boo!
      new_data = `plutil -convert xml1 #{out_fname} -s -o -`.lstrip
      return enclose(:xml1, new_data.rstrip.split(/\n/)) if is_xml?(new_data)

      # Ruh-roh!  Something went wrong!
      return enclose(:unknown, new_data.bytes.map(&:ord))
    ensure
      file_out.close
      file_out.unlink
    end
  end

  def self.enclose(new_format, new_data); { new_format: new_format, data: new_data }; end

  def self.format_of(data)
    magic_word = !data.empty? ? data[0..3] : ""
    case
    when magic_word == "bpli" then :binary1
    when xml?(magic_word)     then :xml1
    when json?(magic_word)    then :json
    else                           :unknown
    end
  end

  def self.json?(prefix); JSON_MARKERS.include?(prefix[0]); end
  def self.xml?(prefix); prefix[0..3] == XML_MARKER; end
end
