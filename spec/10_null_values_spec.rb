# frozen_string_literal: true

RSpec.describe Scrubber, '#scrub' do
  context 'with null values data' do
    it 'generates expected output' do
      input    = File.read('tests/10_null_values/input.json')
      fields   = File.read('tests/10_null_values/sensitive_fields.txt').split("\n")
      expected = File.read('tests/10_null_values/output.json')
      scrubber = Scrubber.new(fields)
      actual   = scrubber.scrub(input)

      expect(Oj.load(actual)).to eq(Oj.load(expected))
    end
  end
end
