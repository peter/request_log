# CHANGELOG

## 0.1.2 (2011-10-25)

* Added explicit sorting by time to Db.filtered_requests method to ensure that the `request_log:print` rake task outputs requests in chronological order.

## 0.1.0

* Removed summary field from log data since it only contained redundant data and we want to trim the size of the log.

## 0.0.1

* Initial version
