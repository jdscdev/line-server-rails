# frozen_string_literal: true

require "async"

class LinesController < ApplicationController
  before_action :validate_and_set_line_index, only: %i[show]

  def show
    @file_lines = {}

    Async do |task|
      task.async do
        @file_lines = Rails.cache.read('file_lines')
      end
    end

    return render(json: { error: 'Out of bonds' }, status: 413) if @line_index > @file_lines.count

    render(json: @file_lines[@line_index])
  rescue StandardError => e
    render(json: { error: e.message }, status: :internal_server_error)
  end

  private

  def validate_and_set_line_index
    params.permit(:index)
    line_index = params[:index].to_i
    return render(json: { error: 'Out of bonds' }, status: 413) if line_index.zero?

    @line_index = line_index
  end
end
