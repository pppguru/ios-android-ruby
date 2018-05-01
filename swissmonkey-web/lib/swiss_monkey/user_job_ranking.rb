module SwissMonkey
  # Provides a ranking algorithm for how well a job fits a user
  class UserJobRanking
    def initialize(job_id, user_id)
      @job = JobPosting.find job_id
      @user = User.find user_id

      @job_entries = 0
      @match = 0

      @job_shifts = @job.shift_configuration_hash
      @user_shifts = @user.shift_configuration_hash
    end

    def rank
      rank_on_position
      rank_on_experience
      rank_on_software_expertise
      rank_on_compensation
      rank_on_shift_preferences

      return 0 unless @job_entries.positive?

      (@match / @job_entries) * 100.0
    end

    private

    def rank_on_shift_preferences
      return unless @job_shifts.any? && @user_shifts.any?

      @job_entries += 1
      @user_shifts.each do |user_shift_id, user_shift_days|
        next unless user_shift_days.any?
        @job_entries += user_shift_days.length
        if @job_shifts[user_shift_id]
          matching_days = @job_shifts[user_shift_id] & user_shift_days
          @match += matching_days.length
        end
      end
    end

    def rank_on_compensation
      return if @job.compensation_type.blank?
      @job_entries += 1
      @match += 1 if @user.salary_configuration&.appropriate_for_job?(@job)
    end

    def rank_on_software_expertise
      job_software_ids = @job.practice_management_systems.map(&:id)
      user_software_ids = @user.practice_management_systems.map(&:id)
      matching_software_ids = job_software_ids & user_software_ids
      @job_entries += user_software_ids.any? ? user_software_ids.length : job_software_ids.length
      @match += matching_software_ids.length
    end

    def rank_on_position
      return if @job.job_position.blank?
      @job_entries += 1
      @match += 1 if @job.job_position_id == @user.job_position
    end

    def rank_on_experience
      return if @job.years_experience.blank?
      @job_entries += 1
      return unless !@user.years_experience_numeric.nil? &&
                    @job.years_experience_numeric <= @user.years_experience_numeric
      @match += 1
    end
  end
end
