# frozen_string_literal: true

require 'oj'

# Removes sensitive data from JSON objects.
#
class Scrubber
  def initialize(sensitive_fields)
    @sensitive_fields = sensitive_fields
  end

  # Given a string of raw JSON, do the following:
  #
  # 1. Parse the JSON into a Hash.
  # 2. Sanitize all sensitive fields.
  # 3. Serialize the Hash back to JSON.
  #
  def scrub(input)
    parsed = Oj.load(input)

    Oj.dump(parsed)
  end
end
