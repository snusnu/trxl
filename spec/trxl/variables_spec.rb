require 'spec_helper'

describe "The formula grammar with a prefilled environment" do
  
  include Trxl::SpecHelper
  
  before :each do
    @parser = Trxl::Calculator.new
  end
  
  it "should raise an error if an undefined variable is referenced" do
    lambda { eval("a") }.should raise_error(Trxl::MissingVariableException)
  end
  
  it "should resolve one letter variables" do
    eval("a / b", { :a => 4, :b => 2 }).should == 4 / 2
  end
  
  it "should resolve multi letter variables" do
    eval("foo / bar", { :foo => 4, :bar => 2 }).should == 4 / 2
  end

  it "should only resolve variables starting with a letter" do
    lambda { parse("foo / 1bar") }.should raise_error(Trxl::FatalParseError)
    lambda { 
      eval("foo / 1bar", { :foo => 4, "1bar".to_sym => 2 }) 
    }.should raise_error(Trxl::FatalParseError)
  end
  
  it "should resolve variables starting with a letter and ending with a number" do
    env = { :foo => 4, "bar1".to_sym => 2 }
    eval("foo / bar1", env).should == 4 / 2
  end

  it "should resolve variables starting with a letter followed by an arbitrary number of letters or digits" do
    env = { :foo => 4, "bar123asd234".to_sym => 2 }
    eval("foo / bar123asd234", env).should == 4 / 2
  end
  
  it "should bind variable declarations in the current environment" do
    eval("a = 1; a;").should == 1
    eval("bar1 = 1; bar1;").should == 1
  end
  
end