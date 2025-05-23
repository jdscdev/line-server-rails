# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LinesController, type: :controller do
  describe 'GET #show' do
    it 'returns line 1 with status 200' do
      get :show, params: { index: 1 }
      expect(response).to have_http_status(:ok)
      json_body = JSON.parse(response.body)
      expect(json_body).to have_key('line')
      expect(json_body['line']).to start_with('In this exercise, you will build and document a system')
    end

    it 'returns line 2 (param as string) with status 200' do
      get :show, params: { index: '2' }
      expect(response).to have_http_status(:ok)
      json_body = JSON.parse(response.body)
      expect(json_body).to have_key('line')
      expect(json_body['line']).to start_with('You may do this in any language (although Ruby, Java, JavaScript, ')
    end

    it 'returns line 4 with status 200' do
      get :show, params: { index: 4 }
      expect(response).to have_http_status(:ok)
      json_body = JSON.parse(response.body)
      expect(json_body).to have_key('line')
      expect(json_body['line']).to eq('However, you should not actively collaborate with others.')
    end

    it 'returns 413 for out-of-range index' do
      get :show, params: { index: 5 }
      expect(response).to have_http_status(:content_too_large)
      json_body = JSON.parse(response.body)
      expect(json_body).to have_key('error')
      expect(json_body['error']).to eq('Line number out of range')
    end

    it 'returns 400 for invalid string index' do
      get :show, params: { index: 'asd' }
      expect(response).to have_http_status(:bad_request)
      json_body = JSON.parse(response.body)
      expect(json_body).to have_key('error')
      expect(json_body['error']).to eq('Invalid line number!')
    end

    it 'returns 400 for invalid index' do
      get :show, params: { index: 0 }
      expect(response).to have_http_status(:bad_request)
      json_body = JSON.parse(response.body)
      expect(json_body).to have_key('error')
      expect(json_body['error']).to eq('Invalid line number!')
    end
  end
end
