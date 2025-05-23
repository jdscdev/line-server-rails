# frozen_string_literal: true

class LinesController < ApplicationController
  def show
    line_text = line_index_instance.read_line(line_index)

    render(json: { line: line_text }, status: :ok)
  rescue IndexError => e
    render(json: { error: e.message }, status: :content_too_large)
  rescue ArgumentError => e
    render(json: { error: e.message }, status: :bad_request)
  rescue StandardError => e
    render(json: { error: e.message }, status: :internal_server_error)
  end

  private

  def line_index_instance
    # Not exactly being injected (DI) but still inverting the lookup, which enables testing and mocking.
    # NOTE: Rails ignores your custom "initialize(args)" (constructors with params) in controllers, in tests and in prod
    Rails.application.config.line_index_instance
  end

  def line_index
    params.permit(:index)
    params[:index].to_i
  end
end
