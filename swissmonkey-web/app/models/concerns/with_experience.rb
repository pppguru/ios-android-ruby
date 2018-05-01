# Commonly shared methods where years experience needs to be stored and calculated
module WithExperience
  extend ActiveSupport::Concern
  include LegacyHelper

  def years_experience_numeric
    years_experience_to_numeric(years_experience)
  end

  def years_experience_label
    years_experience_to_string(years_experience)
  end
end
