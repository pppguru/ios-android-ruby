require 'rails_helper'

RSpec.describe Api::V1::JobController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:token) { 'dfsdfsdfdsf' }
  let(:rda_position) { FactoryGirl.create(:job_position, name: 'RDA') }
  let(:company) { FactoryGirl.create(:company, contact_email: 'test@test.co') }
  let(:zip_code) do
    FactoryGirl.create(:zip_code, latitude: 123, longitude: 456, city: 'Sacramento', zip_code: '95811')
  end
  let(:company_location) { FactoryGirl.create(:company_location, company_id: company.id, zip_code: '95811') }
  let(:user) { FactoryGirl.create(:user, name: 'Joe Joe', role: 'JOBSEEKER', token: token) }
  let(:publication_status) { 'PUBLISHED' }
  let(:job_posting) do
    FactoryGirl.create(:job_posting,
                       publication_status: publication_status,
                       job_position_id: rda_position.id,
                       company_location_id: company_location.id,
                       company_id: company.id)
  end
  let(:json) { JSON.parse(response.body) }

  render_views

  describe 'POST #details' do
    let(:subject) { post :details, params: { authtoken: token, id: job_posting.id } }

    it 'renders an array' do
      user
      subject
      expect(response).to have_http_status(:success)
      expect(assigns(:jobs)).to eq([job_posting])
    end
  end

  describe 'POST #search' do
    let(:search) { nil }
    let(:payload) do
      {
        authtoken: token,
        miles: 20,
        position: [1, 2, 3, 4, 5, 6, 7, 9, 10, 11, 12, 13, 15, 16, 17, 23, rda_position.id],
        search: search
      }
    end
    let(:subject) do
      post :search, params: payload
    end
    let(:json) { JSON.parse(response.body) }
    let(:geocoder_result) { { city: 'Appleton', latitude: 123, longitude: 456 } }

    before :each do
      user
      job_posting
      zip_code
      user.addresses.create(zip_code: '95811')
      allow(SwissMonkey::Geocoder).to receive(:get_coordinates).and_return(geocoder_result)
      allow(controller).to receive(:distance).and_return(10)
    end

    # context 'not signed in' do
    #   let(:token) { nil }
    #   it 'renders without error' do
    #     subject
    #     expect(response).to have_http_status(:success)
    #   end
    # end

    context 'signed in' do
      context 'zip code not provided' do
        it 'renders without error' do
          subject
          expect(response).to have_http_status(:success)
          expect(assigns(:jobs)).not_to be_empty
        end
      end

      context 'zip code provided' do
        let(:search) { '90210' }
        it 'renders without error' do
          subject
          expect(response).to have_http_status(:success)
        end
      end

      # context 'invalid zip code provided' do
      #   let(:search) { 'invalid' }
      #   let(:geocoder_result) { nil }
      #   it 'renders error' do
      #     subject
      #     expect(response).to have_http_status(400)
      #     expect(json['error']).to eq('Enter correct location')
      #   end
      # end
    end

    context 'searching for 3+ years experience' do
      let(:subject) do
        post :search, params: {
          authtoken: token,
          experience: 4
        }
      end

      let(:job_params) do
        { job_position: rda_position, company_location: company_location, publication_status: 'PUBLISHED' }
      end
      let(:job2) { FactoryGirl.create(:job_posting, job_params.merge(years_experience: 'YEARS_2')) }
      let(:job_null) { FactoryGirl.create(:job_posting, job_params.merge(years_experience: nil)) }
      let(:job3) { FactoryGirl.create(:job_posting, job_params.merge(years_experience: 'YEARS_3')) }
      let(:job5) { FactoryGirl.create(:job_posting, job_params.merge(years_experience: 'YEARS_5')) }
      let(:job10) { FactoryGirl.create(:job_posting, job_params.merge(years_experience: 'YEARS_10_PLUS')) }

      let(:jobs) { assigns(:jobs) }

      before :each do
        job2
        job_null
        job3
        job5
        job10
        subject
      end

      it 'does not return candidate with 2 years experience' do
        expect(jobs).not_to include(job2)
      end
      it 'returns candidate with null experience' do
        expect(jobs).to include(job_null)
      end
      it 'returns candidate with 3 years experience' do
        expect(jobs).to include(job3)
      end
      it 'returns candidate with 5 years experience' do
        expect(jobs).to include(job5)
      end
      it 'returns candidate with 10+ years experience' do
        expect(jobs).to include(job10)
      end
    end

    context 'searching for a shift configuration' do
      let(:subject) do
        @request.headers['Content-Type'] = 'application/json'
        @request.headers['Accept'] = 'application/json'
        post :search, params: payload
      end
      let(:payload) do
        {
          shifts: [
            { shiftID: 1, days: ['Monday'] },
            { shiftID: 2, days: ['Tuesday'] },
            { shiftID: 3, days: ['Wednesday'] }
          ],
          position: [rda_position.id],
          toCompensation: '999999',
          miles: 50_000,
          compensationID: 2,
          authtoken: token,
          experience: 5,
          job_type: 'PART_TIME',
          fromCompensation: '1'
        }
      end

      before :each do
        posting = FactoryGirl.create(:job_posting,
                                     publication_status: publication_status,
                                     job_position_id: rda_position.id,
                                     company_location_id: company_location.id,
                                     compensation_type: 'SALARY',
                                     job_type: 'PART_TIME',
                                     years_experience: 'YEARS_4',
                                     company_id: company.id,
                                     compensation_range_low: 50_000,
                                     compensation_range_high: 100_000)
        posting.shift_configurations.create(shift_time: 'MORNING', shift_days: 'Sunday,Monday,Thursday')
        posting.shift_configurations.create(shift_time: 'AFTERNOON', shift_days: 'Tuesday,Wednesday')
        posting.shift_configurations.create(shift_time: 'EVENING', shift_days: 'Wednesday,Friday,Saturday')
      end

      it 'renders successfully' do
        subject
        expect(response).to have_http_status(:success)
      end

      it 'is not empty' do
        subject
        expect(assigns(:jobs)).not_to be_empty
      end
    end
  end

  describe 'POST #apply' do
    let(:subject) do
      user
      post :apply, params: { jobID: job_posting.id, authtoken: token, apiVersion: '1.1' }
    end

    context 'job is closed' do
      let(:publication_status) { 'CLOSED' }

      it 'is renders 400 with error' do
        subject
        expect(response).to have_http_status(400)
        expect(json['error']).to eq('This job has been closed')
      end
    end

    context 'job is published' do
      it 'is successful' do
        subject
        expect(response).to have_http_status(:success)
      end
      it 'creates a job application record' do
        expect { subject }.to(change { JobApplication.count }.by(1))
      end
      it 'sends an email' do
        expect(JobMailer).to receive_message_chain(:user_applied_for_job, :deliver_now!)
        subject
      end
    end
  end
end
