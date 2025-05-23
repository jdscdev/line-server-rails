# frozen_string_literal: true

Rails.application.config.after_initialize do
  # Created here for Dependency Injection in ruby
  Rails.application.config.line_index_instance = LineIndex.new
end
