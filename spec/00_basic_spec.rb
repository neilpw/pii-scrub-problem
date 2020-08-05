# frozen_string_literal: true

RSpec.describe Scrubber, '#scrub' do
  context 'with basic data' do
    it 'generates expected output' do
      input    = File.read('tests/00_basic/input.json')
      fields   = File.read('tests/00_basic/sensitive_fields.txt').split("\n")
      expected = File.read('tests/00_basic/output.json')
      scrubber = Scrubber.new(fields)
      actual   = scrubber.scrub(input)

      expect(Oj.load(actual)).to eq(Oj.load(expected))
    end
  end
end
