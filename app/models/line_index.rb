# frozen_string_literal: true

class LineIndex
  attr_reader :lines_offsets

  FILE_NAME = ENV.fetch('LINE_SERVER_FILE')
  FILE_PATH = File.join(File.dirname(__FILE__), '..', 'files', FILE_NAME)

  def initialize
    file_read_lines = File.open(FILE_PATH, 'r').readlines
    raise('File is empty!') if file_read_lines.count.zero?

    @lines_offsets = get_lines_offsets(file_read_lines)
  rescue StandardError => e
    puts("System failure: #{e.message}")
    Rails.logger.error("System failure: #{e.message}")
    exit(1)
  end

  def read_line(line_offset)
    raise('Invalid line offset!') if line_offset.to_i.negative?
    
    File.open(FILE_PATH, 'r') do |f|
      f.seek(line_offset)
      f.readline
    end
  rescue StandardError => e
    puts("System failure: #{e.message}")
    Rails.logger.error("System failure: #{e.message}")
    exit(1)
  end

  private

  def get_lines_offsets(file_read_lines)
    puts "\n#### Starting Indexing File \"#{FILE_NAME}\" ####\n\n"

    count_lines = 1
    sum_offsets = 0
    lines_offsets_aux = { 1 => 0 }
    draw_indexed_lines_counter(count_lines, file_read_lines.count)

    file_read_lines.each do |line|
      if line.index("\n").present? # Doesn't do anything on last line because last offset has already been saved
        sum_offsets += line.length # Adds next position after \n
        lines_offsets_aux[count_lines += 1] = sum_offsets
        draw_indexed_lines_counter(count_lines, file_read_lines.count)
      end
    end

    puts "\n\n#### Finished Indexing File! ####\n\n"
    lines_offsets_aux
  end

  def draw_indexed_lines_counter(line_index, total_lines)
    print "\rIndexed line #{line_index} out of #{total_lines}"
  end
end
