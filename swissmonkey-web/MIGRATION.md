# Laravel to Rails migration guide

## Part 1: Set up the Schema in Rails

- run `rake db:create`
- run  `rake db:migrate VERSION=20180109043855`

## Part 2: Prepare and export the Laravel MySQL database
- Run the migrate sql script to format the mysql db the right way
- Export mysql tables to sql files using phpstorm
- `cd` into the directory where the export files are stored
- run `replace "swissmonkeydb." "" -- *.sql` to prepare the files for PG import

## Part 3: Populate the Rails database

- Run this import command `psql -d swissmonkey_dev -a -f FILENAME` in the following order:

```
psql -d swissmonkey_dev -a -f swissmonkeydb_zip_codes.sql
psql -d swissmonkey_dev -a -f swissmonkeydb_software_proficiencies.sql
psql -d swissmonkey_dev -a -f swissmonkeydb_salary_configurations.sql
psql -d swissmonkey_dev -a -f swissmonkeydb_shift_configurations.sql
psql -d swissmonkey_dev -a -f swissmonkeydb_practice_management_systems.sql
psql -d swissmonkey_dev -a -f swissmonkeydb_closed_job_reasons.sql
psql -d swissmonkey_dev -a -f swissmonkeydb_job_positions.sql
psql -d swissmonkey_dev -a -f swissmonkeydb_android_users.sql
psql -d swissmonkey_dev -a -f swissmonkeydb_users.sql
psql -d swissmonkey_dev -a -f swissmonkeydb_addresses.sql
psql -d swissmonkey_dev -a -f swissmonkeydb_companies.sql
psql -d swissmonkey_dev -a -f swissmonkeydb_company_locations.sql
psql -d swissmonkey_dev -a -f swissmonkeydb_device_tokens.sql
psql -d swissmonkey_dev -a -f swissmonkeydb_media.sql
psql -d swissmonkey_dev -a -f swissmonkeydb_file_attachments.sql
psql -d swissmonkey_dev -a -f swissmonkeydb_user_certifications.sql
psql -d swissmonkey_dev -a -f swissmonkeydb_users_companies.sql
psql -d swissmonkey_dev -a -f swissmonkeydb_employee_benefits.sql
psql -d swissmonkey_dev -a -f swissmonkeydb_companies_employee_benefits.sql
psql -d swissmonkey_dev -a -f swissmonkeydb_companies_practice_management_systems.sql
psql -d swissmonkey_dev -a -f swissmonkeydb_users_practice_management_systems.sql
psql -d swissmonkey_dev -a -f swissmonkeydb_users_shift_configurations.sql
psql -d swissmonkey_dev -a -f swissmonkeydb_users_software_proficiencies.sql
psql -d swissmonkey_dev -a -f swissmonkeydb_job_postings.sql
psql -d swissmonkey_dev -a -f swissmonkeydb_job_postings_views.sql
psql -d swissmonkey_dev -a -f swissmonkeydb_job_postings_software_proficiencies.sql
psql -d swissmonkey_dev -a -f swissmonkeydb_job_postings_shift_configurations.sql
psql -d swissmonkey_dev -a -f swissmonkeydb_job_postings_practice_management_systems.sql
psql -d swissmonkey_dev -a -f swissmonkeydb_job_applications.sql
psql -d swissmonkey_dev -a -f swissmonkeydb_users_job_notifications.sql
```

- Run the following in a postgres console to ensure that primary key indexes are not stuck:

```
SELECT setval('addresses_id_seq', (SELECT MAX(id) FROM addresses)+1);
SELECT setval('android_users_id_seq', (SELECT MAX(id) FROM android_users)+1);
SELECT setval('closed_job_reasons_id_seq', (SELECT MAX(id) FROM closed_job_reasons)+1);
SELECT setval('companies_id_seq', (SELECT MAX(id) FROM companies)+1);
SELECT setval('company_locations_id_seq', (SELECT MAX(id) FROM company_locations)+1);
SELECT setval('device_tokens_id_seq', (SELECT MAX(id) FROM device_tokens)+1);
SELECT setval('device_tokens_id_seq', (SELECT MAX(id) FROM device_tokens)+1);
SELECT setval('employee_benefits_id_seq', (SELECT MAX(id) FROM employee_benefits)+1);
SELECT setval('file_attachments_id_seq', (SELECT MAX(id) FROM file_attachments)+1);
SELECT setval('job_applications_id_seq', (SELECT MAX(id) FROM job_applications)+1);
SELECT setval('job_positions_id_seq', (SELECT MAX(id) FROM job_positions)+1);
SELECT setval('job_postings_id_seq', (SELECT MAX(id) FROM job_postings)+1);
SELECT setval('job_postings_shift_configurations_id_seq', (SELECT MAX(id) FROM job_postings_shift_configurations)+1);
SELECT setval('job_postings_views_id_seq', (SELECT MAX(id) FROM job_postings_views)+1);
SELECT setval('media_id_seq', (SELECT MAX(id) FROM media)+1);
SELECT setval('practice_management_systems_id_seq', (SELECT MAX(id) FROM practice_management_systems)+1);
SELECT setval('salary_configurations_id_seq', (SELECT MAX(id) FROM salary_configurations)+1);
SELECT setval('shift_configurations_id_seq', (SELECT MAX(id) FROM shift_configurations)+1);
SELECT setval('software_proficiencies_id_seq', (SELECT MAX(id) FROM software_proficiencies)+1);
SELECT setval('users_id_seq', (SELECT MAX(id) FROM users)+1);
SELECT setval('user_certifications_id_seq', (SELECT MAX(id) FROM user_certifications)+1);
SELECT setval('users_job_notifications_id_seq', (SELECT MAX(id) FROM users_job_notifications)+1);
SELECT setval('users_job_notifications_id_seq', (SELECT MAX(id) FROM users_job_notifications)+1);
SELECT setval('zip_codes_id_seq', (SELECT MAX(id) FROM zip_codes)+1);
```

## Part 4: Complete the Rails migration

- run `rake db:migrate`

