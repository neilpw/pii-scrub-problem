# frozen_string_literal: true

RSpec.describe Scrubber, '#scrub' do
  context 'with alphanumeric data' do
    it 'generates expected output' do
      input    = File.read('tests/01_alphanumeric/input.json')
      fields   = File.read('tests/01_alphanumeric/sensitive_fields.txt').split("\n")
      expected = File.read('tests/01_alphanumeric/output.json')
      scrubber = Scrubber.new(fields)
      actual   = scrubber.scrub(input)

      expect(Oj.load(actual)).to eq(Oj.load(expected))
    end
  end
end
