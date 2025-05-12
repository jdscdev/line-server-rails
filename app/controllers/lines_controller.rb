# frozen_string_literal: true

require "async"

class LinesController < ApplicationController
  before_action :validate_and_set_line_index, only: %i[show]

  def show
    line_text = nil
    lines_count = 0
    line_index_instance = Rails.cache.read('line_index_instance') 
    lines_offsets = line_index_instance.lines_offsets

    return render(json: { error: 'Out of bonds' }, status: 413) if @line_index > lines_offsets.keys.count

    Async do |task|
      task.async do
        line_text = line_index_instance.read_line(lines_offsets[@line_index])
      end
    end

    return render(json: { error: 'Out of bonds' }, status: 413) if line_text.nil?

    render(json: { line: line_text })
  rescue StandardError => e
    render(json: { error: e.message }, status: :internal_server_error)
  end

  private

  def validate_and_set_line_index
    params.permit(:index)
    line_index_param = params[:index].to_i
    return render(json: { error: 'Invalid line index!' }, status: :bad_request) if line_index_param.zero?

    @line_index = line_index_param
  end
end
