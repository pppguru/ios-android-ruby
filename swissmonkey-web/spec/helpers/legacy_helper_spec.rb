require 'rails_helper'

RSpec.describe LegacyHelper, type: :helper do
  describe 'miles_range_to_numeric' do
    context 'MILES_30' do
      it 'returns 30' do
        expect(helper.miles_range_to_numeric('MILES_30')).to eq(30)
      end
    end
  end

  describe 'miles_range_id_to_enum' do
    context '7' do
      it 'returns MILES_40' do
        expect(helper.miles_range_id_to_enum(7)).to eq('MILES_40')
      end
    end
  end

  describe 'years_experience_to_numeric' do
    context 'YEARS_10_PLUS' do
      it 'returns 11' do
        expect(helper.years_experience_to_numeric('YEARS_10_PLUS')).to eq(11)
      end
    end
  end

  describe 'years_experience_from_numeric' do
    context '7' do
      it 'returns YEARS_6' do
        expect(helper.years_experience_from_numeric(7)).to eq('YEARS_6')
      end
    end
  end

  describe 'years_experience_to_string' do
    context 'YEARS_6' do
      it 'returns "6 Years"' do
        expect(helper.years_experience_to_string('YEARS_6')).to eq('6 Years')
      end
    end
  end

  describe 'shift_id_to_time' do
    context '2' do
      it 'returns "AFTERNOON"' do
        expect(helper.shift_id_to_time(2)).to eq('AFTERNOON')
      end
    end
  end

  describe 'shift_time_to_id' do
    context 'EVENING' do
      it 'returns 3' do
        expect(helper.shift_time_to_id('EVENING')).to eq(3)
      end
    end
  end

  describe 'compensation_id_to_enum' do
    context '2' do
      it 'returns SALARY' do
        expect(helper.compensation_id_to_enum(2)).to eq('SALARY')
      end
    end
  end

  describe 'job_type_id_to_enum' do
    context '2' do
      it 'returns PART_TIME' do
        expect(helper.job_type_id_to_enum(2)).to eq('PART_TIME')
      end
    end
  end

  describe 'work_availability_id_to_enum' do
    context '2' do
      it 'returns AVAILABLE_AFTER_DATE' do
        expect(helper.work_availability_id_to_enum(2)).to eq('AVAILABLE_AFTER_DATE')
      end
    end
  end
end
