require "spec_helper"

describe GitPlist do
  it "has a version number" do
    expect(GitPlist::VERSION).not_to be nil
  end

  describe "format_of" do
    it "should recognize valid JSON" do
      sample = <<"_END_"
        {
          "int_value": 0,
          "array_value": ["1","2","3"],
          "dict_value": {
            "int_value":0,
            "string_value": "Hello, world!"
          },
          "false_value": false,
          "true_value": true,
          "float_value": 0
        }
_END_
      format = GitPlist.format_of(sample.strip)
      expect(format).to equal(:json)
    end

    it "should recognize valid XML" do
      sample = <<"_END_"
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
          <key>string_value</key>
          <string>Hello, world!</string>
        </dict>
        </plist>
_END_
      format = GitPlist.format_of(sample.strip)
      expect(format).to equal(:xml1)
    end
  end

  context "simple plist" do
  end

  context "complex plist" do
  end

  context "garbage plist" do
  end

  context "broken plist" do
  end

  context "empty plist" do
  end
end
