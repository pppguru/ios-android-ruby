require 'rails_helper'

RSpec.describe SwissMonkey::Sms, type: :class do
  describe 'send' do
    let(:subject) do
      SwissMonkey::Sms.send('9161234567', 'This is a test')
    end
    it 'sends message' do
      expect_any_instance_of(FakeSMS).to receive(:create).with(from: 'abc', to: '+19161234567', body: 'This is a test')
      subject
    end
  end
end
