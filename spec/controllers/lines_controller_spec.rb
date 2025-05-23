# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LinesController, type: :controller do
  let(:mock_line_index) { instance_double(LineIndex) }

  before do
    allow_any_instance_of(LinesController).to receive(:line_index_instance).and_return(mock_line_index)
  end

  describe 'GET #show' do
    it 'returns line 1 with status 200' do
      allow(mock_line_index).to receive(:read_line).with(1).and_return("This is line 1\n")

      get :show, params: { index: 1 }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq({ 'line' => "This is line 1\n" })
    end

    it 'returns line 2 with status 200' do
      allow(mock_line_index).to receive(:read_line).with(2).and_return('This is line 2')

      get :show, params: { index: 2 }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq({ 'line' => 'This is line 2' })
    end

    it 'returns line 2 (param as string) with status 200' do
      allow(mock_line_index).to receive(:read_line).with(2).and_return('This is line 2')

      get :show, params: { index: '2' }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq({ 'line' => 'This is line 2' })
    end

    it 'returns 413 for out-of-range index' do
      allow(mock_line_index).to receive(:read_line).with(3).and_raise(IndexError, 'Line number out of range!')

      get :show, params: { index: 3 }

      expect(response).to have_http_status(:content_too_large)
      expect(JSON.parse(response.body)).to eq({ 'error' => 'Line number out of range!' })
    end

    it 'returns 400 for invalid string index' do
      allow(mock_line_index).to receive(:read_line).with(0).and_raise(ArgumentError, 'Invalid line number!')

      get :show, params: { index: 'asd' }

      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)).to eq({ 'error' => 'Invalid line number!' })
    end

    it 'returns 400 for index 0' do
      allow(mock_line_index).to receive(:read_line).with(0).and_raise(ArgumentError, 'Invalid line number!')

      get :show, params: { index: 0 }

      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)).to eq({ 'error' => 'Invalid line number!' })
    end

    it 'returns 400 for negative index' do
      allow(mock_line_index).to receive(:read_line).with(-1).and_raise(ArgumentError, 'Invalid line number!')

      get :show, params: { index: -1 }

      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)).to eq({ 'error' => 'Invalid line number!' })
    end
  end
end
