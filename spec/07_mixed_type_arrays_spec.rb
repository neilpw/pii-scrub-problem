# frozen_string_literal: true

RSpec.describe Scrubber, '#scrub' do
  context 'with mixed type array data' do
    it 'generates expected output' do
      input    = File.read('tests/07_mixed_type_arrays/input.json')
      fields   = File.read('tests/07_mixed_type_arrays/sensitive_fields.txt').split("\n")
      expected = File.read('tests/07_mixed_type_arrays/output.json')
      scrubber = Scrubber.new(fields)
      actual   = scrubber.scrub(input)

      expect(Oj.load(actual)).to eq(Oj.load(expected))
    end
  end
end
