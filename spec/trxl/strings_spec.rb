require 'spec_helper'

describe "When working with Strings, the Trxl::Calculator" do

  include Trxl::SpecHelper

  before(:each) do
    @parser = Trxl::Calculator.new
  end

  it "should evaluate string literals to strings using double quotes (\"\")" do
    eval("\"Test String\"").should == "Test String"
    eval("s = \"Test String\"; s;").should == "Test String"
  end

  it "should evaluate string literals to strings using single quotes ('')" do
    eval("'Test String'").should == "Test String"
    eval("s = 'Test String'; s;").should == "Test String"
  end

end
