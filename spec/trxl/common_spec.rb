require 'spec_helper'

describe "The parser" do
  
  include Trxl::SpecHelper
  
  before :each do
    @parser = Trxl::Calculator.new
  end
  
  it "should return NULL for an empty string" do
    program =  ""
    eval(program).should == nil
  end
    
  it "should ignore multiple ';' characters (like ;;;)" do
    eval(";").should == nil
    eval(";;").should == nil
    eval("1+1;;").should == 2
  end
  
end