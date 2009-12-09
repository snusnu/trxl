require 'spec_helper'

describe "For commenting, the language" do
  
  include Trxl::SpecHelper
  
  before :each do
    @parser = Trxl::Calculator.new
  end
  
  it "should allow single line comments" do
    eval("# This is only a comment").should be_nil
    eval("# This is only a comment\n").should be_nil
    eval("# This is only a comment a = 5; a;").should be_nil
    eval("a = 5 # This is only a comment").should == 5
    eval("a = 5 # This is only a comment\n").should == 5
    eval("a = 5; # This is only a comment").should == 5
    eval("a = 5; # This is only a comment\n").should == 5
  end

  it "should allow multi line comments" do
    eval("/* This is a multiline comment */ a = 5; a;").should == 5
    eval("a = 5; /* This is a multiline comment */ a;").should == 5

    program = <<-PROGRAM
      a = 1;
      /*
       * This is a multiline comment
       */
      a * 2;
    PROGRAM
    eval(program).should == 2
  end
  
end