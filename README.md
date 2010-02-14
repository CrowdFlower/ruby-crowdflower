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

	job.status["tainted_judgments"] == 0

Note on Patches/Pull Requests
--------------------------------
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but
	bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

Copyright
---------

Copyright &copy; 2009 [Dolores Labs](http://www.doloreslabs.com/). See LICENSE for details.
