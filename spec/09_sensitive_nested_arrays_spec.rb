# frozen_string_literal: true

RSpec.describe Scrubber, '#scrub' do
  context 'with sensitive nested object data' do
    it 'generates expected output' do
      input    = File.read('tests/09_senstive_nested_arrays/input.json')
      fields   = File.read('tests/09_senstive_nested_arrays/sensitive_fields.txt').split("\n")
      expected = File.read('tests/09_senstive_nested_arrays/output.json')
      scrubber = Scrubber.new(fields)
      actual   = scrubber.scrub(input)

      expect(Oj.load(actual)).to eq(Oj.load(expected))
    end
  end
end
