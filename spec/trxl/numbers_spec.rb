require 'spec_helper'

describe "The calculation grammar" do
  
  include Trxl::SpecHelper

  before(:each) do
    @parser = Trxl::Calculator.new
  end

  it "should evaluate a given positive integer number to itself" do
    eval("7").should == 7
  end

  it "should evaluate a given negative integer number to itself" do
    eval("-7").should == -7
  end

  it "should evaluate a given positive real number to itself" do
    eval("7.0").should == 7.0
  end

  it "should evaluate a given negative real number to itself" do
    eval("-7.0").should == -7.0
  end
  
end
