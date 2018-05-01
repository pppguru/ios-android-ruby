require 'rails_helper'

class FakeCoords
  def initialize(success)
    @success = success
  end

  attr_reader :success

  def lat
    0.02
  end

  def lng
    0.21
  end

  def city
    'Sacramento'
  end
end

RSpec.describe SwissMonkey::Geocoder, type: :class do
  let(:address) { '123 Main St, Sacramento, CA 95814' }
  let(:subject) do
    SwissMonkey::Geocoder.get_coordinates(address)
  end

  describe 'get_coordinates' do
    context 'called with an existing zip code' do
      let(:zip) do
        FactoryGirl.create(:zip_code, zip_code: '90210', city: 'Beverly Hills', latitude: 0.00001, longitude: 3.2211)
      end
      let(:address) { '90210' }

      it 'returns a hash with stored zip code data' do
        zip
        expect(subject).to eq(city: 'Beverly Hills',
                              latitude: 0.00001,
                              longitude: 3.2211)
      end
    end

    context 'called with a zip code that doesn\'t exist yet' do
      let(:address) { '90211' }

      before :each do
        allow(Geokit::Geocoders::MultiGeocoder).to receive(:geocode).and_return(FakeCoords.new(true))
      end

      it 'returns a hash with stored zip code data' do
        expect(subject).to eq(city: 'Sacramento',
                              latitude: 0.02,
                              longitude: 0.21)
      end

      it 'saves a new zip code record' do
        expect { subject }.to(change { ZipCode.count }.by(1))
      end
    end

    context 'Geocoder success' do
      before :each do
        allow(Geokit::Geocoders::MultiGeocoder).to receive(:geocode).and_return(FakeCoords.new(true))
      end
      it 'returns a hash with geocoding data' do
        expect(subject).to eq(city: 'Sacramento',
                              latitude: 0.02,
                              longitude: 0.21)
      end
    end

    context 'Geocoder failure' do
      before :each do
        allow(Geokit::Geocoders::MultiGeocoder).to receive(:geocode).and_return(FakeCoords.new(false))
      end
      it 'returns nil' do
        expect(subject).to be_nil
      end
    end
  end
end
