# frozen_string_literal: true

class LineIndex
  attr_reader :lines_offsets, :file_path

  def initialize(file_path)
    @file_path = file_path
    raise(ArgumentError, 'File does not exist!') unless File.exist?(file_path)

    @lines_offsets = index_file
  end

  def read_line(line_number)
    raise(ArgumentError, 'Invalid line number!') if line_number <= 0
    offset = lines_offsets[line_number]
    raise(IndexError, 'Line number out of range!') unless offset

    File.open(file_path, 'r') do |f|
      f.seek(offset)
      f.readline
    end
  rescue => e
    Rails.logger.error("Failed to read line #{line_number}: #{e.message}")
    raise
  end

  private

  def index_file
    puts "\n#### Starting Indexing File \"#{File.basename(file_path)}\" ####\n\n"

    offsets = {}
    current_offset = 0
    line_number = 1

    File.foreach(file_path) do |line|
      draw_indexed_lines_counter(line_number)
      offsets[line_number] = current_offset
      current_offset += line.bytesize
      line_number += 1
    end

    raise 'File is empty!' if offsets.empty?

    puts "\n\n#### Finished Indexing File! ####\n\n"
    offsets
  end

  def draw_indexed_lines_counter(current_line)
    print "\rIndexed line #{current_line}"
  end
end
