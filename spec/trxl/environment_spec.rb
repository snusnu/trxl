require 'spec_helper'

describe "A newly created environment" do
  
  before :each do
    @env = Trxl::Environment.new
  end
  
  it "should be empty" do
    @env.should be_empty
  end
  
  it "should have a depth of 1 (one)" do
    @env.depth.should == 1
  end
  
end

describe "For storing variables" do
  
  before :each do
    @env = Trxl::Environment.new
  end
  
  it "should allow to bind variables to any given value" do
    @env[:a] = "foo"
    @env[:a].should == "foo"
  end
  
  it "should allow to test if it's empty" do
    @env.should be_empty
    @env[:a] = "foo"
    @env.should_not be_empty
  end
  
  it "should allow to assign new values to already initialized variables" do
    @env[:a] = "foo"
    @env[:a].should == "foo"
    @env[:a] = "bar"
    @env[:a].should == "bar"
  end
  
end

describe "For scoping variables" do
  
  before :each do
    @env = Trxl::Environment.new({
      :a => "foo",
      :b => "bar"
    })
  end
  
  it "should allow to enter a new scope" do
    @env.enter_scope
    @env.depth.should == 2
  end
  
  it "should allow to pop any nested scope" do
    @env.enter_scope
    @env.exit_scope
    @env.depth.should == 1
  end
  
  it "should not allow to pop the toplevel scope" do
    lambda { @env.exit_scope }.should raise_error
  end
  
  it "should override any existing variable in a new scope" do
    @env.enter_scope
    @env[:a] = "bam"
    @env[:a].should == "bam"
    @env.exit_scope
    @env[:a].should == "foo"
  end
  
  it "should allow to merge an existing environment into the current local one" do
    other_env = { :c => "c", :d => "d" }
    @env.merge!(other_env)
    @env.local[:c].should == "c"
    @env.local[:a].should == "foo"
    @env.local[:b].should == "bar"
    @env[:c].should == "c"
    @env[:a].should == "foo"
    @env[:b].should == "bar"

    other_env = { :a => "a", :c => "c" }
    @env.merge!(other_env)
    @env.local[:a].should == "a"
    @env.local[:b].should == "bar"
    @env.local[:c].should == "c"
    @env[:a].should == "a"
    @env[:b].should == "bar"
    @env[:c].should == "c"
  end
  
  it "should allow to return a new merged environment leaving the original intact" do
    other_env = { :c => "c", :d => "d" }
    env = @env.merge(other_env)
    env.local[:c].should == "c"
    env.local[:a].should == "foo"
    env.local[:b].should == "bar"
    env[:c].should == "c"
    env[:a].should == "foo"
    env[:b].should == "bar"

    other_env = { :a => "a", :c => "c" }
    env = @env.merge(other_env)
    env.local[:a].should == "a"
    env.local[:b].should == "bar"
    env.local[:c].should == "c"
    env[:a].should == "a"
    env[:b].should == "bar"
    env[:c].should == "c"
  end
  
end
