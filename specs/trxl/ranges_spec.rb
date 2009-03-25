require "#{File.dirname(__FILE__)}/../spec_helper"

describe "When working with Ranges, the Trxl::Calculator" do

  include Trxl::SpecHelper
  
  before(:each) do
    @parser = Trxl::Calculator.new
  end
  
  it "should return arrays for range literal expressions" do
    eval("0..0").should == [ 0 ]
    eval("0..-1").should == [ ]
    eval("0...0").should == [ ]
    eval("0...-1").should == [ ]
    
    eval("1..5").should == [ 1, 2, 3, 4, 5 ]
    eval("1 .. 5").should == [ 1, 2, 3, 4, 5 ]
    eval("a = 1; b = 5; a..b").should == [ 1, 2, 3, 4, 5 ]
    eval("1...5").should == [ 1, 2, 3, 4 ]
    eval("1 ... 5").should == [ 1, 2, 3, 4 ]
    eval("a = 1; b = 5; a...b").should == [ 1, 2, 3, 4 ]
    
    eval("\"a\"..\"a\"").should == [ "a" ]
    eval("\"a\"..\"c\"").should == [ "a", "b", "c" ]
    eval("\"a\" .. \"c\"").should == [ "a", "b", "c" ]
    eval("\"a\"...\"c\"").should == [ "a", "b" ]
    eval("\"a\" ... \"c\"").should == [ "a", "b" ]

    eval("'a'..'a'").should == [ "a" ]
    eval("'a'..'c'").should == [ "a", "b", "c" ]
    eval("'a' .. 'c'").should == [ "a", "b", "c" ]
    eval("'a'...'c'").should == [ "a", "b" ]
    eval("'a' ... 'c'").should == [ "a", "b" ]
    
    eval("'aa'..'aa'").should == [ "aa" ]
    eval("'aa'..'ac'").should == [ "aa", "ab", "ac" ]
    eval("'aa'...'ac'").should == [ "aa", "ab" ]

    eval("1..5 == [ 1, 2, 3, 4, 5 ]").should be_true
    eval("1...5 == [ 1, 2, 3, 4 ]").should be_true
    
    eval("SIZE(1..5)").should == 5
      
    eval("a..b == [ 1, 2 ]", { :a => 1, :b => 2 }).should be_true
    eval("a..c", { :a => 1, :b => nil, :c => 2 }).should == [ 1, 2]
    
    lambda { eval("a..b", { :a => nil, :b => nil }) }.should raise_error
    
  end
  
  it "should store ranges as arrays" do
    eval("a = 1..5; a;").should == [ 1, 2, 3, 4, 5 ]
    eval("a = 1 .. 5; a;").should == [ 1, 2, 3, 4, 5 ]
    eval("a = 1; b = 5; c = a..b; c;").should == [ 1, 2, 3, 4, 5 ]
    eval("a = 1...5; a;").should == [ 1, 2, 3, 4 ]
    eval("a = 1 ... 5; a;").should == [ 1, 2, 3, 4 ]
    eval("a = 1; b = 5; c = a...b; c;").should == [ 1, 2, 3, 4 ]
  end

end

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
