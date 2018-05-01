# Helpers for models with a job_type property
module WithJobType
  extend ActiveSupport::Concern

  def job_type_label
    job_types_enum[job_type] if job_type.present?
  end
end
