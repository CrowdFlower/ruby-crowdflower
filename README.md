CrowdFlower API Gem
========
Currently this is a toolkit for interacting with the CrowdFlower REST API. It may potentially become a complete Ruby gem for accessing and editing [CrowdFlower](http://crowdflower.com.com) jobs. 

## Table of Contents

1. [Getting Started](#getting-started)
2. [Usage and Examples](#usage-and-examples)
3. [API Documentation](#api-documentation)
4. [Contribute](#contribute)
5. [Team](#team)
6. [License](#license)

## Getting Started

#####Require this gem in your ruby file:
    
    require 'crowdflower'

#####Or add this line to your application's Gemfile:

    $ gem 'crowdflower'

#####Then execute:

    $ bundle install

#####Or install it yourself as:

    $ gem install crowdflower


This gem makes use of [CrowdFlower's API](http://success.crowdflower.com/customer/portal/articles/1288323-api-documentation). To find your API key, click on your name in the upper right hand corner and select "Account" from the drop down. To create an account click [here](https://id.crowdflower.com/registrations/new?redirect_url=https%3A%2F%2Fcrowdflower.com%2Fjobs&app=make&__hssc=14529640.6.1397164984954&__hstc=14529640.8f31cd290788fdc43f4da6707700cde6.1396463439689.1397160539873.1397164984954.16&hsCtaTracking=c85b8d58-818e-4f19-a27e-83e8f55da890%7C583ca9bc-a025-43b9-806a-b329df96a8c6).

#####Specifiy your api key directly in your code or store it in a yaml file:

```ruby
API_KEY = "YOUR_API_KEY"

CrowdFlower.connect!( 'CrowdFlower.yaml' )
```

## Usage and Examples 
#####[Example Job](api.crowdflower.com/v1/jobs/418404/) - referenced throught the following examples. 

### Access Job Info

```ruby
require 'crowdflower'

API_KEY = "YOUR_API_KEY"
DOMAIN_BASE = "https://api.crowdflower.com"

CrowdFlower::Job.connect! API_KEY, DOMAIN_BASE

job = CrowdFlower::Job.new(job_id)
job = CrowdFlower::Job.new(418404)
```
### Create Blank Job

```ruby
require 'crowdflower'

API_KEY = "YOUR_API_KEY"
DOMAIN_BASE = "https://api.crowdflower.com"

CrowdFlower::Job.connect! API_KEY, DOMAIN_BASE

title = "Crowdshop for Shoes!"
job = CrowdFlower::Job.create(title)
```

### Copy Existing Job

```ruby
require 'crowdflower'

API_KEY = "YOUR_API_KEY"
DOMAIN_BASE = "https://api.crowdflower.com"
JOB_ID = 418404

CrowdFlower::Job.connect! API_KEY, DOMAIN_BASE

job_one = CrowdFlower::Job.new(job_id)
job_two = job_one.copy
```

### Available Features (Methods)

#####GET - https://crowdflower.com/jobs/418404.json

```ruby
job.get["css"]
job.get["auto_order"]
job.get["units_remain_finalized"]
job.get["secret"]
job.get["support_email"]
job.get["golds_count"]
job.get["units_count"]
job.get["included_countries"]
job.get["desired_requirements"]
job.get["max_judgments_per_unit"]
job.get["instructions"]
job.get["auto_order_timeout"]
job.get["public_data"]
job.get["project_number"]
job.get["problem"]
job.get["created_at"]
job.get["send_judgments_webhook"]
job.get["expected_judgments_per_unit"]
job.get["design_verified"]
job.get["worker_ui_remix"]
job.get["fields"]
job.get["completed_at"]
job.get["auto_order_threshold"]
job.get["min_unit_confidence"]
job.get["minimum_account_age_seconds"]
job.get["units_per_assignment"]
job.get["execution_mode"]
job.get["max_judgments_per_worker"]
job.get["gold"]
job.get["require_worker_login"]
job.get["pages_per_assignment"]
job.get["title"]
job.get["completed"]
job.get["order_approved"]
job.get["minimum_requirements"]
job.get["max_judgments_per_ip"]
job.get["confidence_fields"]
job.get["gold_per_assignment"]
job.get["alias"]
job.get["id"]
job.get["judgments_count"]
job.get["js"]
job.get["cml"]
job.get["excluded_countries"]
job.get["updated_at"]
job.get["language"]
job.get["state"]
job.get["variable_judgments_mode"]
job.get["custom_key"]
job.get["options"]
```

#####UPLOAD (data to create units) 

```ruby
job.upload(filename, type, opts)
job.upload("crowdshopping.csv", "text/csv")
```

#####CHANNELS - http://api.crowdflower.com/v1/jobs/418404/channels

```ruby
job.channels 
job.enable_channels(channels)
job.enable_channels("cf_internal")
```

#####TAGS - https://api.crowdflower.com/jobs/418404/tags

```ruby
tags = "shoes", "shopping", "fashion"
job.add_tags(tags)
job.update_tags("fun", "glitter", "crowdshop")
job.remove_tags("crowdshop") 
```

#####UNITS - http://api.crowdflower.com/v1/jobs/418404/units

```ruby
unit = CrowdFlower::Unit.new(job)
```

#####View

```ruby
unit.all 
unit.all.count
unit.get(unit_id)
```
#####Check on a unit

```ruby
unit.ping
```

#####View a unit's judgments

```ruby
unit.judgments(unit_id)
unit.judgments(444154130)
```

#####Create from scratch

```ruby
unit.create("glitter_color"=>"blue") 
unit.create("glitter_color"=>"blue", gold: true) 
```

#####Create from copy of existing unit

```ruby
unit.copy(unit_id, job_id, data = {})
unit.copy(444154130, 418404, "glitter_color"=>"blue")
```

#####Split

```ruby
unit.split(on, with = " ")
```

#####Update 

```ruby
unit.update(unit_id, params)
unit.update(444154130, "glitter_color"=>"green")
```

#####Make Gold (make the unit a test question)

```ruby
unit.make_gold(unit_id)
```

#####Cancel

```ruby
unit.cancel(unit_id)
```

#####Delete

```ruby
unit.delete(unit_id)
```

#####Request more judgments - nb_judgments = number of additional judgments

```ruby
unit.request_more_judgments(unit_id, nb_judgments = 1)
```

#####ORDERS

```ruby
order = CrowdFlower::Order.new(job)
order.debit(units_count, channels)
order.debit(6, "all")
```

#####PAUSE - can only call on running jobs

```ruby
job.pause
```

#####RESUME - can only call on paused or complete jobs

```ruby
job.resume
```

#####CANCEL - only on running or paused jobs

```ruby
job.cancel
```

#####UPDATE - access of the json attributes (see GET)

```ruby
job.update
job.update("project_number"=>"PN123")
```

#####DELETE

```ruby
job.delete
```

#####WORKERS - http://api.crowdflower.com/v1/jobs/418404/workers

```ruby
worker = CrowdFlower::Worker.new(job) 
```

#####Award a bonus in cents, 200 for $2.00

```ruby
worker.bonus(worker_id, amount, reason=nil)
worker.bonus(23542619, 10, "good job!")

worker.approve(worker_id)
worker.approve(14952322) 

worker.reject(worker_id)
worker.reject(14952322)

worker.ban(worker_id)
worker.ban(14952322)

worker.deban(worker_id)
worker.deban(14952322)

worker.notify(worker_id, subject, message)
worker.notify(23542619, "you earned a bonus!", "good job!")

worker.flag(worker_id, reason=nil)
worker.flag(14952322, "testing")

worker.deflag(worker_id)
worker.deflag(14952322)
```

#####JUDGMENTS - http://api.crowdflower.com/v1/jobs/418404/units/judgments

```ruby
judgment = CrowdFlower::Judgment.new(job) 
judgment.all
judgment.get(judgment_id)
judgment.get(1239592918)

# Admin only
judgment.reject(judgment_id)
judgment.reject(1239592918)

# Return every judgment for the given unit
job.units.judgments(unit_id_number) 
job.units.judgments(444154130) 
```

#####LEGEND - http://api.crowdflower.com/v1/jobs/418404/legend

```ruby
job.legend
```

#####STATUS - parsed json response or access attributes like GET

```ruby
job.status
job.status["golden_units"]
job.status["all_judgments"]
job.status["tainted_judgments"]
job.status["completed_units_estimate"]
job.status["needed_judgments"]
job.status["all_units"]
job.status["completed_non_gold_estimate"]
job.status["completed_gold_estimate"]
job.status["ordered_units"]
```

#####DOWNLOAD_CSV - get csv or zip back of job results

```ruby
job.download_csv(type, filename, opts) 
job.download_csv(full, nil, force:true)
```

#####WORKERS - http://api.crowdflower.com/v1/jobs/418404/workers

```ruby
worker = CrowdFlower::Worker.new(job)

worker.bonus(worker_id, amount, reason=nil)

worker.approve(worker_id)

worker.reject(worker_id)

worker.ban(worker_id)

worker.deban(worker_id)

worker.notify(worker_id, subject, message)

worker.flag(worker_id, reason=nil)

worker.deflag(worker_id)
```

## Helpful Documentation
Judgments: http://success.crowdflower.com/customer/portal/articles/1366723-job-settings---judgments

## Contribute

1. Fork the repo: https://github.com/dolores/ruby-crowdflower.git
2. Create your topic branch (`git checkout -b my_branch`)
3. Make changes and add tests for those changes
3. Commit your changes, making sure not to change the rakefile, version or history (`git commit -am 'Adds cool, new README'`)
4. Push to your branch (`git push origin my_branch`)
5. Create an issue with a link to your branch for the pull request

## Team

Check out the [CrowdFlower Team](http://www.crowdflower.com/team)!

## License

Copyright (c) 2014 CrowdFlower

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Please review our [Terms and Conditions](http://www.crowdflower.com/legal) page for detailed api usage and licensing information.