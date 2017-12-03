require 'json'

module JSON
  def self.is_valid?(json)
    begin
      JSON.parse(json)
      true
    rescue JSON::ParserError
      false
    end
  end
end
