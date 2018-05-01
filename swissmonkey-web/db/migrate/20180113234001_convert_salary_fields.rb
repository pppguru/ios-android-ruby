class ConvertSalaryFields < ActiveRecord::Migration[5.0]
  def change
    add_column :salary_configurations, :range_high, :decimal, precision: 11, scale: 2
    add_column :salary_configurations, :range_low, :decimal, precision: 11, scale: 2

    rename_column :job_postings, :compensation_range_low, :comprange_low
    rename_column :job_postings, :compensation_range_high, :comprange_high

    add_column :job_postings, :compensation_range_low, :decimal, precision: 11, scale: 2
    add_column :job_postings, :compensation_range_high, :decimal, precision: 11, scale: 2

    SalaryConfiguration.all.each do |salary_config|
      if salary_config.salary_range_high.present?
        salary_config.update range_high: salary_config.salary_range_high,
                             range_low: salary_config.salary_range_low
      end
    end

    JobPosting.all.each do |job_posting|
      if job_posting.comprange_high.present?
        job_posting.update compensation_range_high: job_posting.comprange_high,
                           compensation_range_low: job_posting.comprange_low
      end
    end

    remove_column :job_postings, :comprange_high
    remove_column :job_postings, :comprange_low

    remove_column :salary_configurations, :salary_range_high
    remove_column :salary_configurations, :salary_range_low
  end
end
