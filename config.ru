# frozen_string_literal: true

# frozen_string_literal
# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

run Rails.application
Rails.application.load_server
