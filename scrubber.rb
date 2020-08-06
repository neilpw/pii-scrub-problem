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
  # @param sensitive This value is nested within a sensitive value. Some scrub
  #                  methods handle that differently.
  #
  def scrub_value(input, sensitive: false)
    # It would have been nice to make this a case statement, but I don't think
    # that would play nicely with the various Numeric types.
    #
    if input.is_a?(Hash)
      scrub_hash(input)
    elsif input.is_a?(Array)
      scrub_array(input, sensitive: sensitive)
    elsif input.is_a?(String)
      scrub_string(input)
    elsif input.is_a?(Numeric)
      scrub_numeric(input)
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
        # We always scrub values in sensitive fields, and we engage sensitive
        # mode.
        #
        if @sensitive_fields.include?(key)
          scrub_value(value, sensitive: true)
        #
        # We always need to scrub Hashes and Arrays, in case they contain nested
        # objects with sensitive fields.
        #
        elsif value.is_a?(Hash) || value.is_a?(Array)
          scrub_value(value)
        else
          value
        end
    end

    scrubbed
  end

  # Given an Array, return a scrubbed copy.
  #
  def scrub_array(array, sensitive: false)
    array.map do |value|
      if sensitive || value.is_a?(Hash)
        scrub_value(value)
      else
        value
      end
    end
  end

  # Given a String, return a scrubbed copy (all alphanumeric characters replaced
  # with asterisks).
  #
  def scrub_string(input)
    input.gsub(/[A-Za-z0-9]/, '*')
  end

  # Given a Numeric value, return a sanitized copy.
  #
  def scrub_numeric(input)
    scrub_string(input.to_s)
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
