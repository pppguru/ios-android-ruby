require 'rails_helper'

RSpec.describe Api::V1::UserController, type: :controller do
  include Devise::Test::ControllerHelpers
  let(:json) { JSON.parse(response.body) }

  describe 'POST #signup' do
    let(:email) { 'test@user.co' }
    let(:zip_code) { '90210' }
    let(:name) { 'Swiss Monkizzle' }
    let(:password) { 'monkey123' }
    let(:subject) { post :signup, params: { username: email, zip_code: zip_code, name: name, password: password } }

    context 'email already exists' do
      let(:email) { 'already@exists.io' }
      let!(:user) { FactoryGirl.create(:user, email: email) }

      it 'returns an error with 400 code' do
        subject
        expect(response).to have_http_status(400)
        expect(json['error']).to eq('User already exists')
      end
    end

    context 'email does not exist' do
      context 'zip code not provided' do
        let(:zip_code) { nil }
        it 'is successful' do
          subject
          expect(response).to have_http_status(200)
        end
      end

      context 'zip code provided' do
        it 'is successful' do
          subject
          expect(response).to have_http_status(200)
        end
      end
    end
  end

  describe 'POST #validate' do
    let(:token) { 'abcdefg' }
    let(:subject) { post :validate, params: { authtoken: token } }

    context 'user does not exist' do
      it 'should render 400' do
        subject
        expect(response).to have_http_status(400)
      end
    end

    context 'user exists' do
      it 'should be successful' do
        FactoryGirl.create(:user, token: 'abcdefg')
        subject
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'POST #login' do
    let(:username) { 'test@swissmonkey.io' }
    let(:password) { 'test1234' }
    let(:role) { 'JOBSEEKER' }
    let(:subject) do
      post :login, params: { username: username, password: password }
    end
    let(:user) { FactoryGirl.create(:user, email: username, user_name: username, password: password, role: role) }

    context 'email not registered' do
      it 'should respond with error "Email not registered"' do
        subject
        expect(response).to have_http_status(400)
        expect(json['error']).to eq('Email not registered')
      end
    end
    context 'password invalid' do
      it 'should respond with error "Invalid credentials"' do
        user.update password: 'somethingelse'
        subject
        expect(response).to have_http_status(400)
        expect(json['error']).to eq('Invalid credentials')
      end
    end
    context 'user is employer' do
      let(:role) { 'EMPLOYER' }
      it 'should respond with error ' \
      '"Looks like you are trying to sign in as an employer.  Please use www.swissmonkey.io' do
        user
        subject
        expect(response).to have_http_status(400)
        expect(json['error'])
          .to eq('Looks like you are trying to sign in as an employer.  Please use www.swissmonkey.io')
      end
    end
    context 'user is a jobseeker with a valid account' do
      it 'should respond with success and an authtoken' do
        user
        subject
        expect(response).to have_http_status(200)
      end
    end
  end
end
