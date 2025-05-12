# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LineIndex do
  let(:test_file_path) { Rails.root.join('spec/files/test.txt') }

  describe '#initialize' do
    it 'raises error if file does not exist' do
      expect { LineIndex.new('invalid.txt') }.to raise_error(ArgumentError)
    end

    it 'creates line offset index' do
      indexer = LineIndex.new(test_file_path)
      expect(indexer.lines_offsets).to be_a(Hash)
      expect(indexer.lines_offsets.keys.count).to eq(2)
    end
  end

  describe '#read_line' do
    it 'returns the correct line text' do
      indexer = LineIndex.new(test_file_path)
      expect(indexer.read_line(1).strip).to eq('This is test line 1.')
      expect(indexer.read_line(2).strip).to eq('This is test line 2.')
    end

    it 'raises error for invalid line number' do
      indexer = LineIndex.new(test_file_path)
      expect { indexer.read_line(0) }.to raise_error(ArgumentError)
      expect { indexer.read_line('asd') }.to raise_error(ArgumentError)
      expect { indexer.read_line(9999) }.to raise_error(IndexError)
    end
  end
end
