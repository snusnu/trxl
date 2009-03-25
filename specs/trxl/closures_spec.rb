require "#{File.dirname(__FILE__)}/../spec_helper"

describe "For defining closures, the language" do
  
  include Trxl::SpecHelper
  
  before(:each) do
    @parser = Trxl::Calculator.new
  end

  it "should parse lambdas with no parameters" do
    parse("fun() {1}").eval.to_s.should == "fun() {1}"
  end

  it "should parse lambdas with one parameter" do
    parse("fun(x) {x}").eval.to_s.should == "fun(x) {x}"
  end

  it "should parse lambdas with multiple parameters" do
    parse("fun(x,y) {x + y}").eval.to_s.should == "fun(x,y) {x + y}" 
  end
  
  it "should parse lambdas that return another lambda" do
    program =  "fun(x) {fun(y) {x + y}}(5)"
    eval(program).to_s.should == "fun(y) {x + y}"
  end
  

  it "should be able to apply lambdas with no parameters" do
    parse("fun() {2 * 2} ()").eval.should == 4
  end

  it "should be able to apply lambdas with one parameter" do
    parse("fun(x) {x} (1)").eval.should == 1
  end

  it "should be able to apply lambdas with multiple parameters" do
    parse("fun(x,y) {x + y} (5,5)").eval.should == 10
  end

  it "should be able to store lambdas in a variable and apply them later" do
    eval("a = fun(x,y) {x + y}; a(5,5);").should == 10
  end

  it "should be able to return closures, store them in variables and apply them later" do
    program  = "foo = 2;"
    program << "adder = fun(x) {fun(y) {x + y}}(5);"
    program << "adder(2);"
    eval(program).should == 7
  end

  it "should have read access to the enclosing scope in closures" do
    program =  "a = 1;"
    program << "fun(){a}();"
    eval(program).should == 1
  end
  
  it "should have write access to the enclosing scope in closures" do
    program =  "a = 0;"
    program << "fun(x){a = x}(1);"
    program << "a;"
    eval(program).should == 1

    program = <<-PROGRAM
    foo = fun() {
      a = 0;
      fun(y) { a = y }(1);
      a;
    };
    foo();
    PROGRAM
    eval(program).should == 1
  end


  it "should allow multiple statements in a function body" do
    program = <<-PROGRAM
    foo = fun(x) {
      a = 3;
      x + a;
    };
    foo(3)
    PROGRAM
    eval(program).should == 6
  end

  it "should be able to perform arithmetics in function bodies" do
    eval("fun(x,y) {x+y} (5,5)").should == 10
    eval("fun(x,y) {x-y} (5,5)").should == 0
    eval("fun(x,y) {x*y} (5,5)").should == 25
    eval("fun(x,y) {x/y} (10,5)").should == 2
    eval("fun(x,y) {x%y} (10,2)").should == 0
    
    eval("fun(x,y) {x+y*3} (5,5)").should == 20
    eval("fun(x,y) {(x-y)*3} (5,5)").should == 0
    eval("fun(x,y) {(x*y)+5} (5,5)").should == 30
    eval("fun(x,y) {x/(y-3)} (10,5)").should == 5
    eval("fun(x,y) {(x+y)%2} (10,2)").should == 0
  end

  it "should be able to perform recursive calls" do
    program =  <<-PROGRAM
      fact = fun(x) { if(x == 0) 1 else fact(x - 1) * x end};
      fact(5);
    PROGRAM
    eval(program).should == 5*4*3*2*1
  end

  
  it "should allow nested applications of recursive functions" do
    program = <<-PROGRAM
      require 'stdlib/inject';
      inject(0, [[1,2],[3,4]], fun(m, arr) {
        m + inject(0, arr, fun(sum, v) {
          sum + v
        })
      })
    PROGRAM
    lambda { eval(program).should == 10 }.should_not raise_error
  end

  it "should evaluate actual parameters that are function applications" do
    program =  "a = 5;"
    program << "b = 10;"
    program << "sum = fun(x,y) {x + y};"
    program << "div = fun(x,y) {x / y};"
    program << "div(sum(a,b),a);"
    eval(program).should == 3
  end

  it "should be able to apply previously defined closures inside function bodies" do
    program =  "a = 5;"
    program << "b = 10;"
    program << "sum = fun(x,y) {x + y};"
    program << "foo = fun(x,y) {sum(x,y)};"
    program << "foo(a,b);"
    eval(program).should == 15
  end
  
  it "should perform left associative chained applications" do
    program = "fun(x) {fun(y) {x + y}}(5)(5);"
    eval(program).should == 10
    program = "fun(a,b) {fun(c,d) {a * b + c * d}}(5,5)(5,5);"
    eval(program).should == 50
    program =  "sum = fun(x,y) {x + y};"
    program << "fun(a,b) {fun(c,d) {a * b + c * d}}(sum(5,5),sum(5,5))(5,5);"
    eval(program).should == 125
    program =  "sum = fun(x,y) {x + y};"
    program << "mult = fun(x,y) {x * y};"
    program << "fun(a,b) {fun(c,d) {a * b + c * d}}(sum(mult(5,5),5),sum(5,5))(sum(5,5),mult(5,5));"
    eval(program).should == 550
  end

  it "should be able to use function applications as left operand in binary operations" do
    program =  "sum = fun(x,y) {x + y};"
    program << "sum(2,2) + 1"
    eval(program).should == 5
  end

  it "should be able to use function applications as right operand in binary operations" do
    program =  "sum = fun(x,y) {x + y};"
    program << "1 + sum(2,2);"
    eval(program).should == 5
  end

  it "should be able to use function applications as operands in binary operations" do
    program =  "sum = fun(x,y) {x + y};"
    program << "sum(1,2) + sum(3,4)"
    eval(program).should == 10
  end

  it "should be able to use function applications as left operands in binary expressions inside function bodies" do
    program =  "sum = fun(x,y) {x + y};"
    program << "foo = fun(x,y) {sum(x,y) + x};"
    program << "foo(5,10);"
    eval(program).should == 20
  end

  it "should be able to use function applications as right operands in binary expressions inside function bodies" do
    program =  "sum = fun(x,y) {x + y};"
    program << "foo = fun(x,y) {x + sum(x,y)};"
    program << "foo(5,10);"
    eval(program).should == 20
  end

  it "should be able to use function applications as operands in binary expressions inside function bodies" do
    program =  "sum = fun(x,y) {x + y};"
    program << "foo = fun(x,y) {sum(x,y) + sum(x,y)};"
    program << "foo(5,10);"
    eval(program).should == 30
  end

  it "should be able to use predefined function applications as operands in binary expressions" do
    program =  "AVG(10,15,20) / AVG(3,3,3)"
    eval(program).should == 5
  end

  it "should be able to use predefined function applications as operands in binary expressions acting as actual parameters to another predefined function" do
    program =  "ROUND( AVG(10,15,20) / AVG(3,3,3) , 2 )"
    eval(program).should == 5
  end

  it "should be able to use predefined and regular function applications as operands in binary expressions acting as a parameter to another predefined function" do
    program =  "ROUND( AVG(fun(x){x}(10),15,fun(x,y){x+y}(10,10)) / AVG(fun(x){x}(3),3,fun(x,y){x+y}(1,2)) , 2 )"
    eval(program).should == 5
  end

  it "should have the arguments variable available in function bodies" do
    program = <<-PROGRAM
      require 'stdlib/inject';
      sum = fun() { inject(0, arguments, fun(memo, i) { memo + i }); };
      sum(1,2,3,4,5);
    PROGRAM
    eval(program).should == 15
    
    program = <<-PROGRAM
      require 'stdlib/inject';
      sum = fun(x,y) { inject(0, arguments, fun(memo, i) { memo + i }); };
      sum(1,2);
    PROGRAM
    eval(program).should == 3
    
    program = <<-PROGRAM
      require 'stdlib/inject';
      sum = fun(x,y) { inject(0, arguments, fun(memo, i) { memo + i }); };
      sum(1,2,3,4,5);
    PROGRAM
    eval(program).should == 15
    
    program = <<-PROGRAM
      require 'stdlib/inject';
      sum = fun(x,y,z) { inject(0, arguments, fun(memo, i) { memo + i }); };
      sum(1,2);
    PROGRAM
    lambda { eval(program) }.should raise_error(Trxl::WrongNumberOfArgumentsException)
    
    begin
      eval(program)
    rescue Trxl::WrongNumberOfArgumentsException => e
      e.message.should == "2 instead of 3"
    end
  end
  
end
