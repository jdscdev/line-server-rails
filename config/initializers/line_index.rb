# frozen_string_literal: true

Rails.application.config.after_initialize do
  Rails.cache.write('line_index_instance', LineIndex.new)
end
