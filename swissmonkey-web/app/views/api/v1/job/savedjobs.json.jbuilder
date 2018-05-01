json.jobs do
  json.array!(@applications) do |application|
    json.partial! 'api/v1/job/job_posting', job: application.job_posting
  end
end
