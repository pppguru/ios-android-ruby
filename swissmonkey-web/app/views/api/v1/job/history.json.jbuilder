json.jobs do
  json.array!(@views) do |view|
    json.partial! 'api/v1/job/job_posting', job: view.job_posting
  end
end
