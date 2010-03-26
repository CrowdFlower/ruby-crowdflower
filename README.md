# ruby-crowdflower

A toolkit for interacting with CrowdFlower via the REST API.

This is alpha software. Have fun!

Example Usage
-------------

Specifiy either your api key or a yaml file containing the key:
	
	CrowdFlower.connect!( 'CrowdFlower.yml' )
	
Upload a CSV file for a job:

	CrowdFlower::Job.upload( File.dirname(__FILE__) + "/data.csv", "text/csv" )

Copy an existing job into a new one:
	
	new_job = job.copy( :all_units => true )
	
Check the status of a job:

	job.status["tainted_judgments"]



Contributing
------------

1. Fork ruby-crowdflower
2. Create a topic branch - `git checkout -b my_branch`
3. Make your feature addition or bug fix and add tests for it.
4. Commit, but do not mess with the rakefile, version, or history.
5. Push to your branch - `git push origin my_branch`
6. Create an Issue with a link to your branch

Copyright
---------

Copyright &copy; 2010 [Dolores Labs](http://www.doloreslabs.com/). See LICENSE for details.
