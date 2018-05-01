json.partial! 'api/v1/job/job_posting_simple', job: job
json.saved_status job.saved_status(current_user)
