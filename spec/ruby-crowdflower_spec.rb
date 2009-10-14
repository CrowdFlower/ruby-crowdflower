require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe CrowdFlower do
  describe "connecting" do
    it "prevents progress unless a key is specified" do
      lambda { CrowdFlower::Job.all }.should raise_error
    end

    it "connects if a key is specified" do
      connect
      CrowdFlower::Job.all
    end
  end
end

describe CrowdFlower::Job do
  describe "creation" do
    describe "using a CSV data source" do
      before :each do
        connect
      end

      it "connects to CrowdFlower" do

      end

      it "uploads data"
    end

  end

end
