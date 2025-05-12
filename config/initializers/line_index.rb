# frozen_string_literal: true

Rails.application.config.after_initialize do
  file_path = File.join(Rails.application.root, 'app', 'files', ENV.fetch('LINE_SERVER_FILE'))
  Rails.application.config.line_index_instance = LineIndex.new(file_path)
end
