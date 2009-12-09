require 'spec_helper'

Infinity = 1.0 / 0

describe "When evaluating addition expressions, the language" do
  
  include Trxl::SpecHelper

  before(:each) do
    @parser = Trxl::Calculator.new
  end
  
  it "should allow integers as operands" do
    eval("0+0").should == 0 + 0
    eval("0+1").should == 0 + 1
    eval("1+0").should == 1 + 0
    eval("1+1").should == 1 + 1
    eval("2+2").should == 2 + 2
    eval("2+-2").should == 2 + -2
  end
  
  it "should allow floats as operands" do
    eval("0.0+0.0").should         == 0.0 + 0.0
    eval("0.1+1").should           == 0.1 + 1
    eval("1.34+0.23456789").should == 1.34 + 0.23456789
    eval("1.000+1.87").should      == 1.000 + 1.87
    eval("2.0+2.01").should        == 2.0 + 2.01
    eval("2.0+-2.01").should        == 2.0 + -2.01
  end

  it "should allow arbitrary spacing" do
    eval("4 + 2").should         == 4 + 2
    eval("4          +2").should == 4 + 2
    eval("4+          2").should == 4 + 2
    eval("    4  +    2").should == 4 + 2
    eval("4  +  2      ").should == 4 + 2
    eval("   4 + 2     ").should == 4 + 2
  end
  
  it "should allow chained expressions" do
    eval("1 + 1 + 1").should     == 1 + 1 + 1
    eval("1 + 1 + 1 + 1").should == 1 + 1 + 1 + 1
  end
  
end


describe "When evaluating subtraction expressions, the language" do
  
  include Trxl::SpecHelper

  before(:each) do
    @parser = Trxl::Calculator.new
  end
  
  it "should allow integers as operands" do
    eval("0-0").should == 0 - 0
    eval("0-2").should == 0 - 2
    eval("2-2").should == 2 - 2
    eval("5-2").should == 5 - 2
    eval("5--2").should == 5--2
  end

  
  it "should allow floats as operands" do
    eval("0.0-0.0").should          == 0.0 - 0.0
    eval("0.1-2.34").should         == 0.1 - 2.34
    eval("2.12-2.34").should        == 2.12 - 2.34
    eval("5.45678-2.456789").should == 5.45678 - 2.456789
    eval("5.45678--2.456789").should == 5.45678 - -2.456789
  end
  
  it "should allow arbitrary spacing" do
    eval("4 - 2").should         == 4 - 2
    eval("4          -2").should == 4 - 2
    eval("4-          2").should == 4 - 2
    eval("    4  -    2").should == 4 - 2
    eval("4  -  2      ").should == 4 - 2
    eval("   4 - 2     ").should == 4 - 2
  end
  
  it "should perform left associative evaluation in chained expressions" do
    eval("16 - 4 - 2").should == (16 - 4 - 2)
    eval("16 - 4 - 2 - 2").should == (16 - 4 - 2 - 2)
  end
  
  it "should allow to override operator precedence with parentheses" do
    eval("(16 - 4) - 2").should  == (16 - 4) - 2
    eval("16 - (4 - 2)").should  == 16 - (4 - 2)
    eval("(16 - 4) - (2 - 2)").should  == (16 - 4) - (2 - 2)
    eval("16 - (4 - 2) - 2").should  == 16 - (4 - 2) - 2
  end

end 


describe "When evaluating multiplication expressions, the language" do
  
  include Trxl::SpecHelper

  before(:each) do
    @parser = Trxl::Calculator.new
  end
  
  it "should allow integers as operands" do
    eval("0*0").should == 0 * 0
    eval("0*1").should == 0 * 1
    eval("1*0").should == 1 * 0
    eval("1*1").should == 1 * 1
    eval("2*2").should == 2 * 2
    eval("3*4").should == 3 * 4
    eval("3*-4").should == 3 * -4
  end

  
  it "should allow floats as operands" do
    eval("0.0*0.0").should     == 0.0 * 0.0
    eval("0.1*1.0").should     == 0.1 * 1.0
    eval("1.345*0.987").should == 1.345 * 0.987
    eval("1.23*1.45").should   == 1.23 * 1.45
    eval("2.5*2").should       == 2.5 * 2
    eval("3.45*4.45").should   == 3.45 * 4.45
    eval("3.45*-4.45").should   == 3.45 * -4.45
  end

  it "should allow arbitrary spacing" do
    eval("4 * 2").should         == 4 * 2
    eval("4          *2").should == 4 * 2
    eval("4*          2").should == 4 * 2
    eval("    4  *    2").should == 4 * 2
    eval("4  *  2      ").should == 4 * 2
    eval("   4 * 2     ").should == 4 * 2
  end
  
  it "should allow chained expressions" do
    eval("1 * 2 * 3").should     == 1 * 2 * 3
    eval("1 * 2 * 3 * 4").should == 1 * 2 * 3 * 4
  end
  
end


describe "When evaluating division expressions, the language" do
  
  include Trxl::SpecHelper

  before(:each) do
    @parser = Trxl::Calculator.new
  end
  
  it "should allow integers as operands" do
    eval("1/1").should == 1.0 / 1
    eval("0/1").should == 0.0 / 1
    eval("1/2").should == 1.0 / 2
    eval("4/2").should == 4.0 / 2
    eval("3/2").should == 3.0 / 2
    eval("3/-2").should == 3.0 / -2

     # test division by zero
    lambda { eval("1/0") }.should raise_error(Trxl::DivisionByZeroError)
  end

  it "should allow floats as operands" do
    eval("1.0/1.0").should     == 1.0 / 1.0
    eval("0.0/1.0").should     == 0.0 / 1.0
    eval("1.23/2.34").should   == 1.23 / 2.34
    eval("4.2345678/2").should == 4.2345678 / 2
    eval("3/2.123456").should  == 3 / 2.123456
    eval("3/-2.123456").should  == 3 / -2.123456
    
    # TODO think about DivisonByZero vs. Infinity
  end
  
  it "should allow arbitrary spacing" do
    eval("4 / 2").should         == 4 / 2
    eval("4          /2").should == 4 / 2
    eval("4/          2").should == 4 / 2
    eval("    4  /    2").should == 4 / 2
    eval("4  /  2      ").should == 4 / 2
    eval("   4 / 2     ").should == 4 / 2
  end
  
  it "should perform left associative evaluation in chained expressions" do
    eval("16 / 4 / 2").should     == (16 / 4 / 2)
    eval("16 / 4 / 2 / 2").should == (16 / 4 / 2 / 2)
  end

  it "should allow to override operator precedence with parentheses" do
    eval("(16 / 4) / 2").should  == (16 / 4) / 2
    eval("16 / (4 / 2)").should  == 16 / (4 / 2)
    eval("(16 / 4) / (2 / 2)").should  == (16 / 4) / (2 / 2)
    eval("16 / (4 / 2) / 2").should  == 16 / (4 / 2) / 2
  end
  
end


describe "When evaluating modulo expressions, the language" do
  
  include Trxl::SpecHelper

  before(:each) do
    @parser = Trxl::Calculator.new
  end
  
  it "should allow integers as operands" do
    eval("1%1").should == 1 % 1
    eval("4%2").should == 4 % 2
    eval("8%3").should == 8 % 3
    eval("8%-3").should == 8 % -3
    
     # test division by zero
    lambda { eval("1%0") }.should raise_error(Trxl::DivisionByZeroError)
  end
  

  it "should allow floats as operands" do
    eval("1.0%1.0").should == 1.0 % 1.0
    eval("4.0%2.0").should == 4.0 % 2.0
    eval("8.0%3.2").should == 8.0 % 3.2
    eval("8.0%-3.2").should == 8.0 % -3.2
    
     # TODO think about DivisonByZero vs. Infinity
  end
  
  it "should allow arbitrary spacing" do
    eval("4 % 2").should         == 4 % 2
    eval("4          %2").should == 4 % 2
    eval("4%          2").should == 4 % 2
    eval("    4  %    2").should == 4 % 2
    eval("4  %  2      ").should == 4 % 2
    eval("   4 % 2     ").should == 4 % 2
  end
  
  it "should perform left associative evaluation in chained expressions" do
    eval("15 % 5 % 3").should     == (15 % 5 % 3)
    eval("16 % 9 % 4 % 2").should == (16 % 9 % 4 % 2)
  end

  it "should allow to override operator precedence with parentheses" do
    eval("(16 % 4) % 2").should  == (16 % 4) % 2
    eval("16 % (5 % 3)").should  == 16 % (5 % 3)
    eval("(16 % 4) % (5 % 3)").should  == (16 % 4) % (5 % 3)
    eval("16 % (5 % 3) % 2").should  == 16 % (5 % 3) % 2
  end
  
end

describe "When evaluating exponential expressions, the language" do
  
  include Trxl::SpecHelper

  before(:each) do
    @parser = Trxl::Calculator.new
  end
  
  it "should allow integers as operands" do
    eval("1^1").should == 1 ** 1
    eval("4^2").should == 4 ** 2
    eval("8^3").should == 8 ** 3
    eval("8^-3").should == 8 ** -3
  end
  

  it "should allow floats as operands" do
    eval("1.0^1.0").should == 1.0 ** 1.0
    eval("4.0^2.0").should == 4.0 ** 2.0
    eval("8.0^3.2").should == 8.0 ** 3.2
    eval("8.0^-3.2").should == 8.0 ** -3.2
  end
  
  it "should allow arbitrary spacing" do
    eval("4 ^ 2").should         == 4 ** 2
    eval("4          ^2").should == 4 ** 2
    eval("4^          2").should == 4 ** 2
    eval("    4  ^    2").should == 4 ** 2
    eval("4  ^  2      ").should == 4 ** 2
    eval("   4 ^ 2     ").should == 4 ** 2
  end
  
  it "should perform left associative evaluation in chained expressions" do
    eval("2 ^ 2 ^ 2").should     == (2 ** 2 ** 2)
    eval("2 ^ 2 ^ 2 ^ 2").should == (2 ** 2 ** 2 ** 2)
  end
  
end


describe "When evaluating arbitrary arithmetic expressions, the language" do
  
  include Trxl::SpecHelper

  before(:each) do
    @parser = Trxl::Calculator.new
  end

  it "should respect arithmetic operator precedence" do
    eval("2 + 4 * 2 + 2").should  == 2 + 4 * 2 + 2
    eval("2 + 4 / 2 + 2").should  == 2 + 4 / 2 + 2
    eval("2 + 5 % 3 + 2").should  == 2 + 5 % 3 + 2
    eval("2 + 4 ^ 2 + 2").should  == 2 + 4 ** 2 + 2

    eval("2 - 4 * 2 - 2").should  == 2 - 4 * 2 - 2
    eval("2 - 4 / 2 - 2").should  == 2 - 4 / 2 - 2
    eval("2 - 5 % 3 - 2").should  == 2 - 5 % 3 - 2
    eval("2 - 4 ^ 2 - 2").should  == 2 - 4 ** 2 - 2

    eval("2 * 4 * 2 - 2").should  == 2 * 4 * 2 - 2
    eval("8 / 4 / 2 - 2").should  == 8 / 4 / 2 - 2
    eval("8 % 4 % 2 - 2").should  == 8 % 4 % 2 - 2
    eval("2 ^ 2 ^ 2 - 2").should  == 2 ** 2 ** 2 - 2

    eval("2 * 4 * 2 - 2 * 3").should  == 2 * 4 * 2 - 2 * 3
    eval("8 / 4 / 2 - 4 / 2").should  == 8 / 4 / 2 - 4 / 2
    eval("8 % 4 % 2 - 5 % 3").should  == 8 % 4 % 2 - 5 % 3
    eval("2 ^ 2 ^ 2 - 2 ^ 2").should  == 2 ** 2 ** 2 - 2 ** 2

    eval("4 / 2 + 2 * 4 * 2 - 2 * 3").should  == 4 / 2 + 2 * 4 * 2 - 2 * 3
    eval("2 * 2 + 8 / 4 / 2 - 4 / 2").should  == 2 * 2 + 8 / 4 / 2 - 4 / 2
    eval("2 + 4 + 8 % 4 % 2 - 5 % 3").should  == 2 + 4 + 8 % 4 % 2 - 5 % 3
    eval("2 * 2 + 2 ^ 2 ^ 2 - 2 ^ 2").should  == 2 * 2 + 2 ** 2 ** 2 - 2 ** 2

    eval("4 + 2 - 2").should  == 4 + 2 - 2
    eval("4 * 2 / 2").should  == 4 * 2 / 2
    eval("4 * 2 % 2").should  == 4 * 2 % 2
    
    eval("4 - 2 + 2").should  == 4 - 2 + 2
    eval("4 / 2 * 2").should  == 4 / 2 * 2
    eval("4 % 2 * 2").should  == 4 % 2 * 2
    eval("4 ^ 2 * 2").should  == 4 ** 2 * 2
    
  end

  it "should allow to override operator precedence using parentheses" do
    eval("(2 + 4) * (2 + 2)").should  == (2 + 4) *  (2 + 2)
    eval("(2 + 4) / (2 + 2)").should  == (2 + 4).to_f /  (2 + 2)
    eval("(2 + 4) % (2 + 2)").should  == (2 + 4) %  (2 + 2)
    eval("(2 + 4) ^ (2 + 2)").should  == (2 + 4) ** (2 + 2)

    eval("(2 - 4) * (2 - 2)").should  == (2 - 4) *  (2 - 2)
    eval("(2 - 4) / (4 - 2)").should  == (2 - 4).to_f /  (4 - 2)
    eval("(2 - 4) % (4 - 2)").should  == (2 - 4) %  (4 - 2)
    eval("(2 - 4) ^ (2 - 2)").should  == (2 - 4) ** (2 - 2)

    eval("2 * 4 * (2 - 2)").should  == 2 * 4 * (2 - 2)
    eval("8 / (4 / 2) - 2").should  == 8 / (4 / 2) - 2
    eval("8 / (8 / 2 - 2)").should  == 8 / (8 / 2 - 2)
    eval("8 % (5 % 3) - 2").should  == 8 % (5 % 3) - 2
    eval("8 % (4 % 2 - 2)").should  == 8 % (4 % 2 - 2)
    eval("2 ^ (2 ^ 2) - 2").should  == 2 ** (2 ** 2) - 2
    eval("2 ^ (2 ^ 2 - 2)").should  == 2 ** (2 ** 2 - 2)
    
    eval("2 * 4 * (2 - 2) * 3").should  == 2 * 4 * (2 - 2) * 3
    eval("2 * 4 * (2 - 2 * 3)").should  == 2 * 4 * (2 - 2 * 3)
    eval("8 / 4 / (2 - 4) / 2").should  == 8.0 / 4 / (2 - 4) / 2
    eval("8 / 4 / (2 - 8 / 2)").should  == 8.0 / 4 / (2 - 8 / 2)
    eval("8 % 4 % (2 - 6) % 3").should  == 8 % 4 % (2 - 6) % 3
    eval("8 % 4 % (2 - 6 % 3)").should  == 8 % 4 % (2 - 6 % 3)
    eval("2 ^ 2 ^ (2 - 2) ^ 2").should  == 2 ** 2 ** (2 - 2) ** 2
    eval("2 ^ 2 ^ (2 - 2 ^ 2)").should  == 2 ** 2 ** (2 - 2 ** 2)
    
    eval("4 / (2 + 2 * 4) * (2 - 2) * 3").should  == 4 / (2 + 2 * 4) * (2 - 2) * 3
    eval("2 * (2 + 8 / 4 / 2 - 4) / 2").should    == 2 * (2 + 8 / 4 / 2 - 4) / 2
    eval("(2 + 4 + 8 % 4) % 2 - (5 % 3)").should  == (2 + 4 + 8 % 4) % 2 - (5 % 3)
    eval("(2 * 2 + 2) ^ (2 ^ 2) - 2 ^ 2").should  == (2 * 2 + 2) ** (2 ** 2) - 2 ** 2
  end


  it "should allow to use variables as operands" do
    env = { :a => 5, :b => 2, :foo => 3 }
    eval("(((1 + 2 * a) - b * foo) * 2 + a) / foo", env).should == (((1 + 2 * env[:a]) - env[:b] * env[:foo]) * 2 + env[:a]) / env[:foo]
  end

  it "should allow to use function applications as operands" do
    program = <<-PROGRAM
      sum = fun(a,b) { a + b };
      (2 * 2 + sum(2,4)) / 2
    PROGRAM
    eval(program).should == 5
  end

  it "should allow to use function applications and variables as operands" do
    program = <<-PROGRAM
      x = 2; y = 4;
      sum = fun(a,b) { a + b };
      (x * 2 + sum(x,y)) / 2
    PROGRAM
    eval(program).should == 5
  end
  
end