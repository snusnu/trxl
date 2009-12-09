require 'spec_helper'

describe "The language" do
  
  include Trxl::SpecHelper
  
  before(:each) do
    @parser = Trxl::Calculator.new
  end
  
  it "should evaluate the constant 'NULL' to nil" do
    eval("NULL").should be_nil
  end

  it "should evaluate the constant 'TRUE' to true" do
    eval("TRUE").should be_true
  end
  
  it "should evaluate the constant 'FALSE' to false" do
    eval("FALSE").should be_false
  end
  
end
