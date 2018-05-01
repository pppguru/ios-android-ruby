# Commonly-shared code between models that have shift configurations
module WithShifts
  extend ActiveSupport::Concern

  def shift_configuration_hash
    Hash[shift_configurations.map do |shift_configuration|
      [
        shift_configuration.shift_id,
        shift_configuration.shift_days.split(',')
      ]
    end]
  end

  def shift_configurations_legacy
    shift_configurations.map do |sc|
      {
        'shiftID' => sc.shift_id,
        'days' => sc.shift_days.split(',')
      }
    end
  end
end
