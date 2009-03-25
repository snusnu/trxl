require "#{File.dirname(__FILE__)}/../spec_helper"

describe "For writing boolean expressions, the language" do

  include Trxl::SpecHelper
  
  before(:each) do
    @parser = Trxl::Calculator.new
  end

  it "should allow a logical AND operation by using '&&'" do
    eval("TRUE && TRUE").should be_true
    eval("FALSE && FALSE").should be_false
    eval("TRUE && FALSE").should be_false
    eval("FALSE && TRUE").should be_false
    
    eval("TRUE && NULL").should be_false
    eval("NULL && TRUE").should be_false
    eval("NULL && NULL").should be_false
    
    eval("(2 == 2) && (2 == 2)").should be_true

    lambda { eval("TRUE && TRUE && TRUE") }.should_not raise_error
    lambda { eval("TRUE && TRUE && FALSE") }.should_not raise_error
    lambda { eval("(2 == 2) && (2 == 2) && (2 == 2)") }.should_not raise_error
    lambda { eval("(2 == 2) && (2 == 2) && (2 == 3)") }.should_not raise_error
  end
  
  it "should allow a logical OR operation by using '||'" do
    eval("TRUE || TRUE").should be_true
    eval("TRUE || FALSE").should be_true
    eval("FALSE || TRUE").should be_true
    eval("FALSE || FALSE").should be_false
    eval("(2 == 2) || (2 == 2)").should be_true
    eval("(2 == 2) || (2 == 3)").should be_true
    eval("(2 == 3) || (2 == 3)").should be_false
  end
  
  it "should allow a logical NOT operation by using '!'" do
    eval("!TRUE").should be_false
    eval("!FALSE").should be_true
    eval("!1").should be_false
    eval("!(1+1)").should be_false
    eval("!(TRUE || FALSE)").should be_false
    eval("!(TRUE && FALSE)").should be_true
    eval("!(2 == 2)").should be_false
    eval("!(2 == 3)").should be_true
    eval("a = TRUE; !a").should be_false
  end
  
end


describe "For comparing expressions, the language" do

  include Trxl::SpecHelper
  
  before(:each) do
    @parser = Trxl::Calculator.new
  end

  it "should allow to test if two expressions are equal by using '=='" do
    eval("(TRUE == TRUE)").should be_true
    eval("(FALSE == FALSE)").should be_true
    eval("(TRUE == FALSE)").should be_false
    eval("(NULL == NULL)").should be_true
    
    eval("2.0 == 1.999999999").should         == (2.0 == 1.999999999)
    eval("2.0 == 2.000000001").should         == (2.0 == 2.000000001)
    eval("1.333333333 == 1.333333333").should == (1.333333333 == 1.333333333)
    
    eval("'foo' == 'foo'").should be_true
    eval("'foo' == 'bar'").should be_false
    
    eval("'foo' != 'foo'").should be_false
    eval("'foo' != 'bar'").should be_true
  end

  it "should allow to test if two expressions are not equal by using '!='" do
    eval("(TRUE != TRUE)").should be_false
    eval("(TRUE != FALSE)").should be_true
    eval("(FALSE != FALSE)").should be_false
    eval("(NULL != NULL)").should be_false
    
    eval("2.0 != 1.999999999").should         == (2.0 != 1.999999999)
    eval("2.0 != 2.000000001").should         == (2.0 != 2.000000001)
    eval("1.333333333 != 1.333333334").should == (1.333333333 != 1.333333334)
  end

  it "should allow to compare two expressions by using '<'" do
    eval("(1 < 1)").should be_false
    eval("(1 < 2)").should be_true
    eval("(2 < 1)").should be_false
    
    eval("2.0 < 1.999999999").should         == (2.0 < 1.999999999)
    eval("2.0 < 2.000000001").should         == (2.0 < 2.000000001)
    eval("1.333333333 < 1.333333332").should == (1.333333333 < 1.333333332)
    eval("1.333333333 < 1.333333333").should == (1.333333333 < 1.333333333)
    eval("1.333333333 < 1.333333334").should == (1.333333333 < 1.333333334)
  end

  it "should allow to compare two expressions by using '>'" do
    eval("(1 > 1)").should be_false
    eval("(2 > 1)").should be_true
    eval("(1 > 2)").should be_false
    
    eval("2.0 > 1.999999999").should         == (2.0 > 1.999999999)
    eval("2.0 > 2.000000001").should         == (2.0 > 2.000000001)
    eval("1.333333333 > 1.333333332").should == (1.333333333 > 1.333333332)
    eval("1.333333333 > 1.333333333").should == (1.333333333 > 1.333333333)
    eval("1.333333333 > 1.333333334").should == (1.333333333 > 1.333333334)
  end

  it "should allow to compare two expressions by using '<='" do
    eval("(1 <= 1)").should be_true
    eval("(1 <= 2)").should be_true
    eval("(2 <= 1)").should be_false
    
    eval("2.0 <= 1.999999999").should         == (2.0 <= 1.999999999)
    eval("2.0 <= 2.000000001").should         == (2.0 <= 2.000000001)
    eval("1.333333333 <= 1.333333332").should == (1.333333333 <= 1.333333332)
    eval("1.333333333 <= 1.333333333").should == (1.333333333 <= 1.333333333)
    eval("1.333333333 <= 1.333333334").should == (1.333333333 <= 1.333333334)
  end

  it "should allow to compare two expressions by using '>='" do
    eval("(1 >= 1)").should be_true
    eval("(2 >= 1)").should be_true
    eval("(1 >= 2)").should be_false
    
    eval("2.0 >= 1.999999999").should         == (2.0 >= 1.999999999)
    eval("2.0 >= 2.000000001").should         == (2.0 >= 2.000000001)
    eval("1.333333333 >= 1.333333332").should == (1.333333333 >= 1.333333332)
    eval("1.333333333 >= 1.333333333").should == (1.333333333 >= 1.333333333)
    eval("1.333333333 >= 1.333333334").should == (1.333333333 >= 1.333333334)
  end
  
end