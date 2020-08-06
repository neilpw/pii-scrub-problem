# frozen_string_literal: true

RSpec.describe Scrubber, '#scrub' do
  context 'with nested object data' do
    it 'generates expected output' do
      input    = File.read('tests/06_nested_object/input.json')
      fields   = File.read('tests/06_nested_object/sensitive_fields.txt').split("\n")
      expected = File.read('tests/06_nested_object/output.json')
      scrubber = Scrubber.new(fields)
      actual   = scrubber.scrub(input)

      expect(Oj.load(actual)).to eq(Oj.load(expected))
    end
  end
end
