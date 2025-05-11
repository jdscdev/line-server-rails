# frozen_string_literal: true

class LineIndex
  def initialize
    dict_lines = {}
    count = 0

    file_path = File.join(File.dirname(__FILE__), '..', 'files', 'small_file.txt')
    IO.foreach(file_path) { |x| dict_lines[count += 1] = x }

    Rails.cache.write('file_lines', dict_lines)
  end
end
