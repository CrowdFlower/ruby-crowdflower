$: << File.dirname(__FILE__) + "/../lib"

require 'rubygems'
require 'crowdflower'
require 'json'

API_KEY   = ENV["API_KEY"]
DOMAIN_BASE = ENV["DOMAIN_BASE"] || "https://api.localdev.crowdflower.com:8443"

unless API_KEY && API_KEY.size > 3
  puts <<EOF

  These integration tests interact with api.crowdflower.com.
  In order to run them, you will need to specify your API key.

  This file is meant only as a reference - please understand
  what you are doing before using the API - you are responsible
  for your usage.

EOF

  exit 1
end

# If you turn this on, tasks will be posted on CrowdFlower and your
# account will be charged. This is inadvisable for anyone other than
# CrowdFlower employees.
I_AM_RICH = ENV["CF_LIVE_TRANSACTIONS"] == "true"

if I_AM_RICH
  puts "*** LIVE TRANSACTIONS ENABLED - THIS TEST RUN WILL BE CHARGED ***"
  puts
end

def wait_until
  10.times do
    if yield
      return
    end
    sleep 5 
  end
  raise "Condition not met in a reasonable time period"
end

def assert(truth)
  unless truth
    raise "Condition not met"
  end
end

def assert_exception_raised expected_exception_class
  begin
    yield
  rescue expected_exception_class
    return
  end
  raise "exception #{expected_exception_class} has not been raised"
end


def say(msg)
  $stdout.puts msg
end


say "defining multiple api keys"
(job_subclass_with_valid_custom_key = Class.new(CrowdFlower::Job)).connect! API_KEY, DOMAIN_BASE
(job_subclass_with_invalid_custom_key = Class.new(CrowdFlower::Job)).connect! 'invalid api key', DOMAIN_BASE
job_subclass_with_no_custom_key = Class.new(CrowdFlower::Job)

say "no default api key"
assert_exception_raised(CrowdFlower::UsageError) {CrowdFlower::Job.create("job creation should fail")}
assert_exception_raised(CrowdFlower::UsageError) {job_subclass_with_no_custom_key.create("job creation should fail")}
assert_exception_raised(CrowdFlower::APIError) {job_subclass_with_invalid_custom_key.create("job creation should fail")}
assert job_subclass_with_valid_custom_key.create("should be ok").units.ping['count']

say "invalid default api key"
CrowdFlower.connect! "invalid default api key", DOMAIN_BASE
assert_exception_raised(CrowdFlower::APIError) {CrowdFlower::Job.create("job creation should fail")}
assert_exception_raised(CrowdFlower::APIError) {job_subclass_with_no_custom_key.create("job creation should fail")}
assert_exception_raised(CrowdFlower::APIError) {job_subclass_with_invalid_custom_key.create("job creation should fail")}
assert job_subclass_with_valid_custom_key.create("should be ok").units.ping['count']

say "Connecting to the API"
CrowdFlower.connect! API_KEY, DOMAIN_BASE

assert CrowdFlower::Job.create("should be ok").units.ping['count']
assert job_subclass_with_no_custom_key.create("should be ok").units.ping['count']
assert job_subclass_with_valid_custom_key.create("should be ok").units.ping['count']
assert_exception_raised(CrowdFlower::APIError) {job_subclass_with_invalid_custom_key.create("job creation should fail")}
# Add this test to check your URL
#assert CrowdFlower::Base.connection.public_url == "localdev.crowdflower.com:80"

say "Uploading a test CSV"
job = CrowdFlower::Job.upload(File.dirname(__FILE__) + "/sample.csv", "text/csv")

say "Trying to get all jobs"
assert CrowdFlower::Job.all.first["id"] == job.id

say "-- Waiting for CrowdFlower to process the data"
wait_until { job.get["units_count"] == 4 }

say "Adding some more data"
job.upload(File.dirname(__FILE__) + "/sample.csv", "text/csv")

say "-- Waiting for CrowdFlower to process the data"
# You could also register a webhook to have CrowdFlower notify your
# server.
wait_until { job.get["units_count"] == 8 }

say "Checking ping."
assert job.units.ping['count'] == 8
assert job.units.ping['done'] == true

say "Getting the units for this job."
assert job.units.all.size == 8

say "Copying the existing job to a new one."
job2 = job.copy :all_units => true

say "-- Waiting for CrowdFlower to finish copying the job."
# You could also register a webhook to have CrowdFlower notify your
# server.
wait_until { job2.get["units_count"] == 8 }

say "Checking the status of the job."
assert job.status["tainted_judgments"] == 0

say "Adding title, instructions, and problem to the job."
job.update({:title => 'testtt',
            :instructions => 'testttt fdsf sfds fsdfs fesfsdf', 
            :cml => '<cml:text label="Text" class="unmodified" validates="required"/>'})

say "Registering a webhook."
job.update :webhook_uri => "http://localhost:8080/crowdflower"

say "Tags"
assert job.tags.empty?
job.update_tags ["testing_123", "testing_456"]
assert job.tags.map{|t| t["name"]}.sort == ["testing_123", "testing_456"]
job.remove_tags ["testing_123"]
assert job.tags.map{|t| t["name"]} == ["testing_456"]
job.add_tags ["testing_789"]
assert job.tags.map{|t| t["name"]} == ["testing_456", "testing_789"]

say "Ordering the job."
order = CrowdFlower::Order.new(job)
unit_count = 8
order.debit(8)
wait_until { job.get["state"].casecmp('running') == 0}

say "Canceling the unit."
unit_id = job.units.all.to_a[0][0]
unit = CrowdFlower::Unit.new(job)
wait_until { unit.get(unit_id)['state'] == 'judgable' }
puts unit.cancel(unit_id).inspect
assert unit.get(unit_id)['state'] == 'canceled'

say "Webhook test needs to be written."
#job.test_webhook

say ">-< Tests complete. >-<"
