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

    scrubbed = scrub_value(parsed)

    Oj.dump(scrubbed)
  end

  # Given any valid JSON type, scrub it for sensitive data.
  #
  def scrub_value(input)
    # It would have been nice to make this a case statement, but I don't think
    # that would play nicely with the various Numeric types.
    #
    if input.is_a?(Hash)
      input # not yet supported
    elsif input.is_a?(Array)
      input # not yet supported
    elsif input.is_a?(String)
      input # not yet supported
    elsif input.is_a?(Numeric)
      input # not yet supported
    elsif input.is_a?(TrueClass) || input.is_a?(FalseClass)
      input # not yet supported
    elsif input.is_a?(NilClass)
      input # not yet supported
    else
      raise "Invalid input type: #{input} <#{input.class}>"
    end
  end
end
