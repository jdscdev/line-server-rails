# frozen_string_literal: true

Rails.application.config.after_initialize do
  file_path = File.join(Rails.application.root, 'app', 'files', ENV.fetch('LINE_SERVER_FILE'))\

  begin
    Rails.cache.write('line_index_instance', LineIndex.new(file_path))
  rescue StandardError => e
    Rails.logger.fatal("Failed to initialize LineIndex: #{e.message}")
    raise
  end
end
