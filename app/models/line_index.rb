# frozen_string_literal: true

class LineIndex
  attr_reader :lines_offsets, :filepath

  def initialize
    filename = ENV.fetch('LINE_SERVER_FILE', '')
    raise(ArgumentError, 'Missing filename!') if filename.blank?

    @filepath = File.join(Rails.application.root, 'app', 'files', File.basename(filename))
    raise(ArgumentError, 'File does not exist!') unless File.exist?(@filepath)

    @lines_offsets = index_file
  end

  def read_line(line_number)
    raise(ArgumentError, 'Invalid line number!') if line_number.to_i <= 0

    offset = lines_offsets[line_number]
    raise(IndexError, 'Line number out of range!') if offset.blank?

    File.open(filepath, 'r') do |f|
      f.seek(offset)
      f.readline
    end
  end

  private

  # rubocop:disable Rails/Output
  def index_file
    puts "\n#### Starting Indexing File \"#{File.basename(filepath)}\" ####\n\n"

    offsets = {}
    current_offset = 0
    line_number = 1

    File.foreach(filepath) do |line|
      draw_indexed_lines_counter(line_number)
      offsets[line_number] = current_offset
      current_offset += line.bytesize
      line_number += 1
    end

    raise(StandardError, 'File is empty!') if offsets.empty?

    puts "\n\n#### Finished Indexing #{line_number -= 1} lines from File! ####\n\n"
    offsets
  end

  def draw_indexed_lines_counter(current_line)
    print "\rIndexed #{current_line} line(s)"
  end
  # rubocop:enable Rails/Output
end
