json.jobs do
  json.partial! 'api/v1/job/job_posting', collection: @jobs, as: :job
end
