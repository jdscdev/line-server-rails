# frozen_string_literal: true

class LinesController < ApplicationController
  def show
    line_index_instance = Rails.cache.fetch('line_index_instance')

    line_text = line_index_instance.read_line(line_index)

    render(json: { line: line_text }, status: :ok)
  rescue IndexError
    render(json: { error: 'Line number out of range' }, status: 413)
  rescue ArgumentError => e
    render(json: { error: e.message }, status: :bad_request)
  rescue StandardError => e
    render(json: { error: e.message }, status: :internal_server_error)
  end

  private

  def line_index
    params.permit(:index)
    params[:index].to_i
  end
end
