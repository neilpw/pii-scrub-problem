require 'oj'

class Scrubber
  def initialize(sensitive_fields)
    @sensitive_fields = sensitive_fields
  end

  def scrub(input)
    input
  end
end
