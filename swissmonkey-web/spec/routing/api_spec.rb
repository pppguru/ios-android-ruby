require 'rails_helper'

RSpec.describe 'API routes', type: :routing do
  def test_path(endpoint)
    "#{api_prefix}#{base_path}#{endpoint}"
  end

  describe '/api/v1.0' do
    let(:api_prefix) { '/api/v1.0' }
    let(:base_path) { '' }

    describe 'misc' do
      it 'GET /dropdown/data is routable' do
        expect(get: test_path('/dropdown/data')).to route_to(controller: 'api/v1', action: 'datasets')
      end
    end

    describe '/settings' do
      let(:base_path) { '/settings' }
      let(:controller) { 'api/v1/settings' }

      it 'POST /update is routable' do
        expect(post: test_path('/update')).to route_to(controller: controller, action: 'update')
      end

      it 'POST /viewed is routable' do
        expect(post: test_path('/viewed')).to route_to(controller: controller, action: 'viewed')
      end

      it 'POST /apinotifications is routable' do
        expect(post: test_path('/apinotifications')).to route_to(controller: controller, action: 'apinotifications')
      end
    end

    describe '/profile' do
      let(:base_path) { '/profile' }
      let(:controller) { 'api/v1/profile' }

      it 'POST /upload is routable' do
        expect(post: test_path('/upload')).to route_to(controller: controller, action: 'upload')
      end

      it 'POST /download is routable' do
        expect(post: test_path('/download')).to route_to(controller: controller, action: 'download')
      end

      it 'POST /info is routable' do
        expect(post: test_path('/info')).to route_to(controller: controller, action: 'info')
      end

      it 'POST /save is routable' do
        expect(post: test_path('/save')).to route_to(controller: controller, action: 'save')
      end

      it 'POST /delete is routable' do
        expect(post: test_path('/delete')).to route_to(controller: controller, action: 'delete')
      end
    end

    describe '/user' do
      let(:base_path) { '/user' }
      let(:controller) { 'api/v1/user' }

      it 'POST /login is routable' do
        expect(post: test_path('/login')).to route_to(controller: controller, action: 'login')
      end

      it 'POST /logout is routable' do
        expect(post: test_path('/logout')).to route_to(controller: controller, action: 'logout')
      end

      it 'POST /forgot is routable' do
        expect(post: test_path('/forgot')).to route_to(controller: controller, action: 'forgot')
      end

      it 'POST /signup is routable' do
        expect(post: test_path('/signup')).to route_to(controller: controller, action: 'signup')
      end

      it 'POST /deactivate is routable' do
        expect(post: test_path('/deactivate')).to route_to(controller: controller, action: 'deactivate')
      end

      it 'POST /activate is routable' do
        expect(post: test_path('/activate')).to route_to(controller: controller, action: 'activate')
      end

      it 'POST /reset is routable' do
        expect(post: test_path('/reset')).to route_to(controller: controller, action: 'reset')
      end

      it 'POST /deviceregistration is routable' do
        expect(post: test_path('/deviceregistration'))
          .to route_to(controller: controller, action: 'device_registration')
      end

      it 'POST /accept_privacy_policy is routable' do
        expect(post: test_path('/accept_privacy_policy'))
          .to route_to(controller: controller, action: 'accept_privacy_policy')
      end

      it 'POST /privacy_policy_status is routable' do
        expect(post: test_path('/privacy_policy_status'))
          .to route_to(controller: controller, action: 'privacy_policy_status')
      end
    end

    describe '/job' do
      let(:base_path) { '/job' }
      let(:controller) { 'api/v1/job' }

      it 'POST /details/1 is routable' do
        expect(post: test_path('/details/1')).to route_to(controller: controller, action: 'details', id: '1')
      end
      it 'POST /search is routable' do
        expect(post: test_path('/search')).to route_to(controller: controller, action: 'search')
      end
      it 'POST /save is routable' do
        expect(post: test_path('/save')).to route_to(controller: controller, action: 'save')
      end
      it 'POST /apply is routable' do
        expect(post: test_path('/apply')).to route_to(controller: controller, action: 'apply')
      end
      it 'POST /jobs is routable' do
        expect(post: test_path('/jobs')).to route_to(controller: controller, action: 'jobs')
      end
      it 'POST /applications is routable' do
        expect(post: test_path('/applications')).to route_to(controller: controller, action: 'applications')
      end
      it 'POST /savedjobs is routable' do
        expect(post: test_path('/savedjobs')).to route_to(controller: controller, action: 'savedjobs')
      end
      it 'POST /history is routable' do
        expect(post: test_path('/history')).to route_to(controller: controller, action: 'history')
      end
    end
  end
end
