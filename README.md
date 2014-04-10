CrowdFlower API Gem
========
Currently this is a toolkit for interacting with the CrowdFlower REST API. It may potentially become a complete Ruby gem for accessing and editing [CrowdFlower](http://crowdflower.com.com) jobs. 

## Table of Contents

1. [Getting Started](#getting-started)
2. [Usage and Examples](#usage-and-examples)
3. [Contribute](#contribute)
4. [Team](#team)
5. [License](#license)

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

* [Jobs](#job)
* [Judgments](#judgment)
* [Units](#unit)
* [Workers](#worker)

###Jobs

#####Create
  ```ruby
  require 'crowdflower'

  API_KEY = "YOUR_API_KEY"
  DOMAIN_BASE = "https://api.crowdflower.com"

  CrowdFlower::Job.connect! API_KEY, DOMAIN_BASE

  title = "Crowdshop for Shoes!"
  new_job = CrowdFlower::Job.create(title)
  ```

#####Get Information on Any Job
The get command allows you to access any job's parsed JSON data. To access a job's JSON from your browser, go to api.crowdflower.com/v1/jobs/{your_job_id}.json. Here's an example: http://api.crowdflower.com/v1/jobs/418404.json. 

When you use the get method you can receive all of the JSON for a given job or you can access attributes by using the key name in the get call: 

  ```ruby
  # GET JOB ID
  p "NEW JOB ID: #{new_job.get["id"]}"
  ```
  
    $ "NEW JOB ID: 418404"
  

#####Units: Had some issues calling units on job

#####Copy

#####Status
  ```ruby
  new_job.status 
  # or specify hash key
  new_job.status["all_units"]
  ```

#####Upload: Two methods, need to explore more

#####Legend: Not sure what this is used for

#####Download CSV: Still not sure why some are .csv and some are zip files

#####Pause

#####Resume

#####Cancel 

#####Update

#####Delete

#####Channels

#####Enable Channels

#####Tags
  ```ruby

  # Add Tags
  tags = "shoes", "shopping", "fashion"
  new_job.add_tags(tags)

  # Update Tags - replaces exisiting tags
  tags = "fun", "glitter"
  new_job.update_tags(tags)

  # Remove Tags
  tags = "fun"
  new_job.remove_tags(tags)
  ```

========

###Judgments

#####All
#####Get
#####Reject

========

###Units

#####All
#####Get
#####Ping
#####Judgments
#####Create
#####Copy
#####Split
#####Update
#####Make Gold
#####Cancel
#####Delete
#####Request More Judgments

========

###Workers

#####Bonus
#####Approve
#####Reject
#####Ban
#####Deban
#####Notifty
#####Flag
#####Deflag

========

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