require 'json'

module JSON
  #
  # Check whether the given json is valid
  # @param json [String] the JSON to validate
  #
  def self.is_valid?(json)
    begin
      JSON.parse(json)
      true
    rescue JSON::ParserError
      false
    end
  end
end
