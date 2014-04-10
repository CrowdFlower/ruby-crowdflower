CrowdFlower API Gem
========
Currently this is a toolkit for interacting with the CrowdFlower REST API. It may potentially become a complete Ruby gem for accessing and editing [CrowdFlower](http://crowdflower.com.com) jobs. 

## Table of Contents

1. [Intstall](#Install)
2. [Usage](#usage)
3. [Breakdown](#breakdown)
4. [Contribute](#contribute)
5. [Team](#team)
6. [License](#license)

## Install
Require it in your ruby file:
    
    require 'crowdflower'

Or add this line to your application's Gemfile:

    $ gem 'crowdflower'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install crowdflower

## Usage

This gem makes use of [CrowdFlower's Human API](http://success.crowdflower.com/customer/portal/articles/1288323-api-documentation). Please check out our [Terms and Conditions](http://www.crowdflower.com/legal) page for detailed usage and licensing information.

#####Specifiy either your api key or a yaml file containing the key:

```ruby
CrowdFlower.connect!( 'CrowdFlower.yaml' )
```

## Classes Breakdown

* [Base](#base)
* [Job](#job)
* [Judgment](#judgment)
* [Order](#order)
* [Unit](#unit)
* [Worker](#worker)

###Base Class

###Job Class
  * Create
  ```ruby
  require 'crowdflower'

  API_KEY = "UGTKhMZMLi_ZdsqoFJ3V"
  DOMAIN_BASE = "https://api.crowdflower.com"

  CrowdFlower::Job.connect! API_KEY, DOMAIN_BASE

  title = "Crowdshop for Shoes!"
  new_job = CrowdFlower::Job.create(title)
  ```
  * Get
  ```ruby
  # GET JOB ID
  p "NEW JOB ID: #{new_job.get["id"]}"
  ```

  * Units: Had some issues calling units on job

  * Copy

  * Status
  ```ruby
  new_job.status 
  # or specify hash key
  new_job.status["all_units"]
  ```

  * Upload: Two methods, need to explore more

  * Legend: Not sure what this is used for

  * Download CSV: Still not sure why some are .csv and some are zip files

  * Pause

  * Resume

  * Cancel 

  * Update

  * Delete

  * Channels

  * Enable Channels

  * Tags
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

###Judgment Class
  * All
  * Get
  * Reject

###Order Class
  * Debit

###Unit Class
  * All
  * Get
  * Ping
  * Judgments
  * Create
  * Copy
  * Split
  * Update
  * Make Gold
  * Cancel
  * Delete
  * Request More Judgments

###Worker Class

####Methods, Examples and Bugs
  * Bonus
  * Approve
  * Reject
  * Ban
  * Deban
  * Notifty
  * Flag
  * Deflag

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