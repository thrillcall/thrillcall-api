module ThrillcallAPI
  class Error < StandardError
    def initialize(details = {})
      super("#{details[:type]}: #{details[:message]}")
    end
  end
end