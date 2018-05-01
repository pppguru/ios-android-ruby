# See http://ruby-doc.org/core-1.9.3/Time.html#method-i-strftime
formats = {
  dayofweek: '%A',
  dayofweek_short: '%a',
  month_and_year: '%B %Y',
  short_ordinal: ->(time) { time.strftime("%B #{time.day.ordinalize}") },
  day_ordinal: ->(time) { time.strftime(time.day.ordinalize.to_s) },
  hour: '%l',
  hour_with_minute_padded: '%H:%M',
  hour_with_minute: '%l:%M',
  hour_with_minute_second: '%l:%M:%S',
  hour_with_minute_meridian: '%l:%M %P',
  hour_with_minute_meridian_no_space: '%l:%M%P',
  hour_with_meridian: '%l %P',
  meridian: '%P',
  minute: '%M',
  month_slash_date: '%-m/%-d',
  mdy: '%-m/%-d/%Y',
  mdy_with_time: '%-m/%-d/%Y %l:%M %P',
  ymd: '%Y/%m/%d',
  mmddyyyy: '%m/%d/%Y',
  mysql_format: '%Y-%m-%d',
  mysql_time_format: '%H:%M:%S',
  mysql_date_time_format: '%Y-%m-%d %H:%M:%S',
  full_date: '%B %-d, %Y',
  full_date_with_dow: '%A, %B %-d, %Y',
  month_name_day: '%B %-d',
  month_abbrev: '%b',
  day_only: '%-d',
  field_format: '%Y-%m-%dT%H:%M'
}

formats.each_pair do |key, val|
  Time::DATE_FORMATS[key] = val
  Date::DATE_FORMATS[key] = val
end
