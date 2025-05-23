# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LineIndex do
  describe '#initialize' do
    describe 'when file is incorrect' do
      it 'raises error if file is nil' do
        allow(ENV).to receive(:fetch).with('LINE_SERVER_FILE', '').and_return('')
        expect { LineIndex.new }.to raise_error(ArgumentError, 'Missing filename!')
      end

      it 'raises error if file is empty' do
        allow(ENV).to receive(:fetch).with('LINE_SERVER_FILE', '').and_return(nil)
        expect { LineIndex.new }.to raise_error(ArgumentError, 'Missing filename!')
      end

      it 'raises error if file does not exist' do
        allow(ENV).to receive(:fetch).with('LINE_SERVER_FILE', '').and_return('invalid.txt')
        expect { LineIndex.new }.to raise_error(ArgumentError, 'File does not exist!')
      end

      it 'raises error if file is empty' do
        allow(ENV).to receive(:fetch).with('LINE_SERVER_FILE', '').and_return('empty.txt')
        allow(File).to receive(:join).and_return('spec/files/empty.txt')
        expect { LineIndex.new }.to raise_error(StandardError, 'File is empty!')
      end
    end

    describe 'when file is correct' do
      let(:indexer) { LineIndex.new }

      before do
        allow(ENV).to receive(:fetch).with('LINE_SERVER_FILE', '').and_return('test.txt')
        allow(File).to receive(:join).and_return('spec/files/test.txt')
      end

      it 'creates line offset indexes' do
        expect(indexer.lines_offsets).to be_a(Hash)
        expect(indexer.lines_offsets.keys.count).to eq(2)
      end

      it 'creates line offset returns correct lines numbers and lines offsets' do
        expect(indexer.lines_offsets).to be_a(Hash)
        expect(indexer.lines_offsets.keys.first).to eq(1)
        expect(indexer.lines_offsets.values.first).to eq(0)
        expect(indexer.lines_offsets.keys.last).to eq(2)
        expect(indexer.lines_offsets.values.last).to eq(21)
      end

      it 'prints lines into console' do
        allow($stdout).to receive(:puts)
        LineIndex.new
        expect($stdout).to have_received(:puts).with("\n#### Starting Indexing File \"test.txt\" ####\n\n")
        expect($stdout).to have_received(:puts).with("\n\n#### Finished Indexing 2 lines from File! ####\n\n")
      end
    end
  end

  describe '#read_line' do
    let(:indexer) { LineIndex.new }

    before do
      allow(ENV).to receive(:fetch).with('LINE_SERVER_FILE', '').and_return('test.txt')
      allow(File).to receive(:join).and_return('spec/files/test.txt')
    end

    it 'returns the correct line text' do
      expect(indexer.read_line(1).strip).to eq('This is test line 1.')
      expect(indexer.read_line(2).strip).to eq('This is test line 2.')
    end

    it 'raises error for empty or nil line number' do
      expect { indexer.read_line('') }.to raise_error(ArgumentError, 'Invalid line number!')
      expect { indexer.read_line(nil) }.to raise_error(ArgumentError, 'Invalid line number!')
    end

    it 'raises error for invalid line number' do
      expect { indexer.read_line(-1) }.to raise_error(ArgumentError, 'Invalid line number!')
      expect { indexer.read_line(0) }.to raise_error(ArgumentError, 'Invalid line number!')
      expect { indexer.read_line('asd') }.to raise_error(ArgumentError, 'Invalid line number!')
      expect { indexer.read_line(3) }.to raise_error(IndexError, 'Line number out of range!')
    end
  end
end
