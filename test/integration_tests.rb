$: << File.dirname(__FILE__) + "/../lib"

require 'rubygems'
require 'crowdflower'
require 'json'

API_KEY   = ENV["API_KEY"]

unless API_KEY && API_KEY.size > 5
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
    sleep 1
  end
  raise "Condition not met in a reasonable time period"
end

def assert(truth)
  unless truth
    raise "Condition not met"
  end
end

def say(msg)
  $stdout.puts msg
end

say "Connecting to the API"
CrowdFlower.connect! API_KEY, true

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

say "Registering a webhook."
job.update :webhook_uri => "http://localhost:8080/crowdflower"

say "Adding title, instructions, and problem to the job."
job.update({:title => 'testtt', :instructions => 'testttt fdsf sfds fsdfs fesfsdf', :problem => '<cml:text label="Text" class="unmodified"/>' })

say "Ordering the job."
order = CrowdFlower::Order.new(job)
unit_count = 8
order.debit(8)
wait_until { job.status["needed_judgments"] == 24}

say "Canceling the unit."
unit_id = job.units.all.to_a[0][0]
unit = CrowdFlower::Unit.new(job)
assert unit.get(unit_id)['state'] == 'judgable'
puts unit.cancel(unit_id).inspect
assert unit.get(unit_id)['state'] == 'new'

say "Webhook test needs to be written."
#job.test_webhook

say ">-< Tests complete. >-<"
