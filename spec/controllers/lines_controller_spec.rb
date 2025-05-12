# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LinesController, type: :controller do
  before do
    file_path = Rails.root.join('spec/files/test.txt')
    line_index_instance = LineIndex.new(file_path)
    allow(Rails.cache).to receive(:fetch).and_return(line_index_instance)
  end

  describe 'GET #show' do
    it 'returns line 1 with status 200' do
      get :show, params: { index: 1 }
      expect(response).to have_http_status(:ok)
      json_body = JSON.parse(response.body)
      expect(json_body).to have_key('line')
      expect(json_body['line']).to start_with('This is test line 1.')
    end

    it 'returns line 2 with status 200' do
      get :show, params: { index: 2 }
      expect(response).to have_http_status(:ok)
      json_body = JSON.parse(response.body)
      expect(json_body).to have_key('line')
      expect(json_body['line']).to start_with('This is test line 2.')
    end

    it 'returns 413 for out-of-range index' do
      get :show, params: { index: 999 }
      expect(response).to have_http_status(413)
    end

    it 'returns 400 for invalid string index' do
      get :show, params: { index: 'asd' }
      expect(response).to have_http_status(400)
    end

    it 'returns 400 for invalid index' do
      get :show, params: { index: 0 }
      expect(response).to have_http_status(400)
    end
  end
end
