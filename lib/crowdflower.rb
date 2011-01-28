require 'httparty'

%w{base job unit judgment order worker}.each do |file|
  require File.dirname(__FILE__) +"/crowdflower/" + file
end
