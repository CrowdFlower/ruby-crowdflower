require 'httparty'

%w{base.rb job.rb unit.rb judgment.rb order.rb patches/httparty.rb}.each do |file|
  require File.dirname(__FILE__) +"/ruby-crowdflower/" + file
end