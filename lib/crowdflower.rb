require 'httparty'

%w{base job unit judgment order}.each do |file|
  require File.dirname(__FILE__) +"/crowdflower/" + file
end
