require 'rails_helper'

RSpec.describe Api::V1::ProfileController, type: :controller do
  include ActionDispatch::TestProcess
  # include Rack::Test::Methods
  include Devise::Test::ControllerHelpers

  let(:token) { 'dfsdfsdfdsf' }
  let(:rda_position) { FactoryGirl.create(:job_position, name: 'RDA') }
  let(:job_position2) { FactoryGirl.create(:job_position, name: 'Pos 2') }
  let(:user) { FactoryGirl.create(:user, name: 'Joe Joe', role: 'JOBSEEKER', token: token) }
  let(:user2) { FactoryGirl.create(:user, email: 'something@el.se', name: 'Joe Joe', role: 'JOBSEEKER') }
  let(:file) { fixture_file_upload('Adam-Weber.png') }
  let(:file2) { fixture_file_upload('butterfly.jpg') }
  let(:json) { JSON.parse(response.body) }

  render_views

  describe 'POST #delete' do
    context 'apiVersion 1.1' do
      let(:user_id) { user.id }
      let(:subject) do
        user
        post :delete, params: { authtoken: token, id: attachment.id, apiVersion: '1.1' }
      end
      let!(:attachment) { FactoryGirl.create(:file_attachment, user_id: user_id, attachment_type: 'profile') }

      context 'attachment belongs to current user' do
        it 'removes a FileAttachment record' do
          expect { subject }.to(change { FileAttachment.count }.by(-1))
        end
        it 'should respond with success' do
          subject
          expect(response).to have_http_status(:success)
        end
        it 'should render json array of files' do
          subject
          expect(json['files']).to be_an(Array)
        end
      end

      context 'attachment does not belong to current user' do
        let(:user_id) { user2.id }
        it 'should not remove attachment' do
          expect { subject }.not_to(change { FileAttachment.count })
        end
        it 'should respond with 400' do
          subject
          expect(response).to have_http_status(400)
          expect(json['error']).to eq('File not found')
        end
      end
    end
  end

  describe 'POST #info' do
    before :each do
      user.job_positions << rda_position
      user.users_job_types.create(job_type: 'FULL_TIME')
      user.users_job_types.create(job_type: 'PART_TIME')
      post :info, params: { authtoken: token }
    end

    it 'renders successfully' do
      expect(response).to have_http_status(:success)
    end

    it 'payload contains job types' do
      expect(json['job_types']).to include('FULL_TIME')
      expect(json['job_types']).to include('PART_TIME')
    end
  end

  describe 'POST #upload' do
    let(:subject) do
      user
      post :upload, params: params
    end

    shared_examples 'successful single upload' do
      it 'should work' do
        subject
        expect(response).to have_http_status(:success)
      end
      it 'should add 1 attachment to the database' do
        expect { subject }.to(change { FileAttachment.count }.by(1))
      end
    end

    context 'keys is a string opened and closed by parentheses' do
      let(:params) do
        { authtoken: token, type: 'images', keys: "(\ndatakey00\n)", datakey00: file }
      end
      it_behaves_like 'successful single upload'
    end

    context 'keys is a simple string' do
      let(:params) do
        { authtoken: token, type: 'images', keys: 'datakey00', datakey00: file }
      end
      it_behaves_like 'successful single upload'
    end

    context 'keys is an array' do
      let(:params) do
        { authtoken: token, type: 'images', keys: ['datakey00'], datakey00: file }
      end
      it_behaves_like 'successful single upload'
    end

    context 'keys is an array (alt format)' do
      let(:params) do
        { authtoken: token, type: 'images', 'keys[]' => 'datakey00', datakey00: file }
      end
      it_behaves_like 'successful single upload'
    end

    context 'multiple files' do
      let(:params) do
        { authtoken: token, type: 'images', keys: %w[file0 file1], file0: file, file1: file2 }
      end
      it 'should work' do
        subject
        expect(response).to have_http_status(:success)
      end
      it 'should not raise error' do
        expect { subject }.not_to raise_error
      end
      it 'should add 2 attachments to the database' do
        expect { subject }.to(change { FileAttachment.count }.by(2))
      end
      it 'should render json array of files' do
        subject
        expect(json['files']).to be_an(Array)
      end
    end
  end

  describe 'POST #save' do
    let(:board_certified) { 1 }
    let(:payload) do
      {
        aboutMe: '',
        addressLine1: '',
        addressLine2: '',
        authtoken: token,
        bilingual_languages: '',
        boardCretifiedID: board_certified,
        city: 'New',
        email: user.email,
        experienceID: 2,
        files: [
          {
            filename: 'dpang99999gmailcomA691A98F796A0749227B0DC7E5EA799F1BCC.JPG',
            id: 1,
            type: 'profile',
            url: 'https://s3.amazonaws.com/swissmonkey-production/file_attachments/files/000/000/001/original/dpang99999gmailcomA691A98F796A0749227B0DC7E5EA799F1BCC.JPG?1518725685'
          }
        ],
        from_salary_range: '',
        image: [],
        image_url: [],
        licenseNumber: '',
        licenseVerified: 1,
        locationRangeID: '',
        name: 'Donald Pang',
        newPracticeSoftware: '',
        phoneNumber: '',
        positionID: [rda_position.id, job_position2.id],
        practiceManagementID: [],
        profile: 'dpang99999gmailcomA691A98F796A0749227B0DC7E5EA799F1BCC.JPG',
        profile_url: 'https://s3.amazonaws.com/swissmonkey-production/file_attachments/files/000/000/001/original/dpang99999gmailcomA691A98F796A0749227B0DC7E5EA799F1BCC.JPG?1518725685',
        recomendationLettrs: [],
        recomendationLettrs_url: [],
        resume: [],
        resume_url: [],
        salary: '',
        shifts: [],
        skills: [],
        state: 'YORk',
        to_salary_range: '',
        video: [],
        video_url: [],
        zipcode: '12345',
        job_types: %w[PART_TIME TEMP]
      }
    end

    let(:subject) { post :save, params: payload }

    before(:each) do
      user.user_certifications.create
      allow(SwissMonkey::Geocoder).to receive(:get_coordinates).and_return(city: 'ABC',
                                                                           latitude: 123,
                                                                           longitude: 456)
    end

    it 'renders successfully' do
      subject
      expect(response).to have_http_status(:success)
    end

    it 'updates position ids' do
      subject
      expect(user.reload.job_positions.map(&:id)).to eq([rda_position.id, job_position2.id])
    end

    it 'updates license verified' do
      expect(user.user_certifications.first.license_verified).to be_falsey
      subject
      expect(user.reload.user_certifications.first.license_verified).to be_truthy
    end

    it 'updates license verified' do
      subject
      user.reload
      expect(user.job_types).to include('PART_TIME')
      expect(user.job_types).to include('TEMP')
    end

    context 'boardCretified = 1' do
      it 'sets certified_by_board to true' do
        expect(user.user_certifications.first.certified_by_board).to be_falsey
        subject
        expect(user.reload.user_certifications.first.certified_by_board).to be_truthy
      end
    end

    context 'boardCretified = 2' do
      let(:board_certified) { 2 }
      it 'sets certified_by_board to false' do
        user.user_certifications.first.update certified_by_board: true
        expect(user.user_certifications.first.certified_by_board).to be_truthy
        subject
        expect(user.reload.user_certifications.first.certified_by_board).to be_falsey
      end
    end
  end
end
