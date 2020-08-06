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
      scrub_hash(input)
    elsif input.is_a?(Array)
      scrub_array(input)
    elsif input.is_a?(String)
      scrub_string(input)
    elsif input.is_a?(Numeric)
      input # not yet supported
    elsif boolean?(input)
      scrub_boolean(input)
    elsif input.is_a?(NilClass)
      input # not yet supported
    else
      raise "Invalid input type: #{input} <#{input.class}>"
    end
  end

  # Given a Hash, return a scrubbed copy.
  #
  def scrub_hash(input)
    scrubbed = {}

    input.each do |key, value|
      scrubbed[key] =
        if @sensitive_fields.include?(key)
          scrub_value(value)
        else
          value
        end
    end

    scrubbed
  end

  # Given an Array, return a scrubbed copy.
  #
  def scrub_array(array)
    array.map { |value| scrub_value(value) }
  end

  # Given a String, return a scrubbed copy (all alphanumeric characters replaced
  # with asterisks).
  #
  def scrub_string(input)
    input.gsub(/[A-Za-z0-9]/, '*')
  end

  # Given a Boolean (i.e. true or false), return a single-dash string.
  #
  def scrub_boolean(input)
    '-'
  end

  def boolean?(value)
    value.is_a?(TrueClass) || value.is_a?(FalseClass)
  end
end
