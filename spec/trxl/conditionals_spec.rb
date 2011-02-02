require 'spec_helper'

describe "For conditional evaluation, the language" do

  include Trxl::SpecHelper

  before(:each) do
    @parser = Trxl::Calculator.new
  end

  it "should be able to evaluate conditional 'if' expressions without elsif and else branches" do
    program =  "test = fun(x) { if(x) TRUE end };"
    eval(program + "test(TRUE)").should be_true
    eval(program + "test(FALSE)").should be_nil
  end

  it "should be able to evaluate conditional 'if' expressions with only an else branch" do
    program = <<-PROGRAM
      if(TRUE)
        TRUE
      else
        FALSE
      end
    PROGRAM
    eval(program).should be_true

    program = <<-PROGRAM
      if(FALSE)
        TRUE
      else
        FALSE
      end
    PROGRAM
    eval(program).should be_false

    program = <<-PROGRAM
      if(NULL)
        TRUE
      else
        FALSE
      end
    PROGRAM
    eval(program).should be_false

    program = <<-PROGRAM
      if(NULL != NULL)
        TRUE
      else
        FALSE
      end
    PROGRAM
    eval(program).should be_false
  end

  it "should be able to evaluate nested 'if' expressions" do
    program = <<-PROGRAM
      if(TRUE)
        if(TRUE)
          TRUE
        else
          FALSE
        end
      else
        FALSE
      end
    PROGRAM
    eval(program).should be_true

    program = <<-PROGRAM
      x = 1;
      if(TRUE)
        if(TRUE)
          x
        else
          FALSE
        end
      else
        FALSE
      end
    PROGRAM
    eval(program).should == 1

    program = <<-PROGRAM
    foo = fun() {
      if(TRUE)
        if(TRUE)
          TRUE
        else
          FALSE
        end
      else
        FALSE
      end
    };
    foo()
    PROGRAM
    eval(program).should be_true

    program = <<-PROGRAM
    foo = fun() {
      if(TRUE)
        if(TRUE)
          "if branch"
        else
          FALSE
        end
      elsif(2 == 3)
        FALSE
      elsif(2 == 4)
        FALSE
      else
        FALSE
      end
    };
    foo()
    PROGRAM
    eval(program).should == "if branch"

    program = <<-PROGRAM
    foo = fun() {
      if(FALSE)
        if(TRUE)
          TRUE
        else
          FALSE
        end
      elsif(TRUE)
        if(TRUE)
          "first elsif branch"
        else
          FALSE
        end
      elsif(2 == 4)
        FALSE
      else
        FALSE
      end
    };
    foo()
    PROGRAM
    eval(program).should == "first elsif branch"

    program = <<-PROGRAM
    foo = fun() {
      if(FALSE)
        if(TRUE)
          TRUE
        else
          FALSE
        end
      elsif(FALSE)
        if(TRUE)
          "first elsif branch"
        else
          FALSE
        end
      elsif(TRUE)
         if(TRUE)
          "second elsif branch"
        else
          FALSE
        end
      else
        FALSE
      end
    };
    foo()
    PROGRAM
    eval(program).should == "second elsif branch"

    program = <<-PROGRAM
    foo = fun() {
      if(FALSE)
        if(TRUE)
          TRUE
        else
          FALSE
        end
      elsif(FALSE)
        if(TRUE)
          "first elsif branch"
        else
          FALSE
        end
      elsif(FALSE)
        if(TRUE)
          "second elsif branch"
        else
          FALSE
        end
      else
        if(TRUE)
          "else branch"
        else
          FALSE
        end
      end
    };
    foo()
    PROGRAM
    eval(program).should == "else branch"
  end

  it "should be able to evaluate conditional 'if' expressions with multiple elsif and an else branch" do
    program = <<-PROGRAM
    foo = fun() {
      if(2 == 2)
        0
      elsif(2 == 3)
        1
      elsif(2 == 4)
        2
      else
        3
      end
    };
    foo();
    PROGRAM
    eval(program).should == 0

    program = <<-PROGRAM
    foo = fun() {
      if(2 == 1)
        0
      elsif(2 == 2)
        1
      elsif(2 == 3)
        2
      else
        3
      end
    };
    foo();
    PROGRAM
    eval(program).should == 1

    program = <<-PROGRAM
    foo = fun() {
      if(2 == 0)
        0
      elsif(2 == 1)
        1
      elsif(2 == 2)
        2
      else
        3
      end
    };
    foo();
    PROGRAM
    eval(program).should == 2

    program = <<-PROGRAM
    foo = fun() {
      if(2 == 0)
        0
      elsif(2 == 1)
        1
      elsif(2 == 3)
        2
      else
        3
      end
    };
    foo();
    PROGRAM
    eval(program).should == 3

    program = <<-PROGRAM
    foo = fun(value) {
      if(value <=  5000)
        22.02
      elsif(value <= 12000)
        18.75
      elsif(value <= 25000)
        15.92
      elsif(value <= 50000)
        12.72
      elsif(value >  50000)
        10.32
      else
        NULL
      end
    };
    foo(13000);
    PROGRAM
    eval(program).should == 15.92
  end

  it "should allow an arbitrary number of statements inside if/elsif/else expressions" do
    program = <<-PROGRAM
    foo = fun() {
      if(2 == 2)
        a = 0;
        a
      elsif(2 == 1)
        b = 1;
        b
      elsif(2 == 3)
        c = 2;
        c
      else
        d = 3;
        d
      end
    };
    foo();
    PROGRAM
    eval(program).should == 0

    program = <<-PROGRAM
    foo = fun() {
      if(2 == 0)
        a = 0;
        a
      elsif(2 == 2)
        b = 1;
        b
      elsif(2 == 3)
        c = 2;
        c
      else
        d = 3;
        d
      end
    };
    foo();
    PROGRAM
    eval(program).should == 1

    program = <<-PROGRAM
    foo = fun() {
      if(2 == 0)
        a = 0;
        a
      elsif(2 == 1)
        b = 1;
        b
      elsif(2 == 2)
        c = 2;
        c
      else
        d = 3;
        d
      end
    };
    foo();
    PROGRAM
    eval(program).should == 2

    program = <<-PROGRAM
    foo = fun() {
      if(2 == 0)
        a = 0;
        a
      elsif(2 == 1)
        b = 1;
        b
      elsif(2 == 3)
        c = 2;
        c
      else
        d = 3;
        d
      end
    };
    foo();
    PROGRAM
    eval(program).should == 3
  end

  it "should allow arbitrary expressions as conditional expression" do
    program =  "test = fun(x) {if(x == 0) TRUE else FALSE end};"
    program << "test(0)"
    eval(program).should be_true
    program =  "test = fun(x) {if(2*2 == 4) TRUE else FALSE end};"
    program << "test(0)"
    eval(program).should be_true
    program =  "test = fun(x) {if(TRUE) TRUE else FALSE end};"
    program << "test(0)"
    eval(program).should be_true
    program =  "test = fun(x) {if(x) TRUE else FALSE end};"
    program << "test(TRUE)"
    eval(program).should be_true
    program =  "test = fun(x) {if(x) TRUE else FALSE end};"
    program << "test(FALSE)"
    eval(program).should be_false
    program =  "x = TRUE;"
    program << "test = fun(x) {if(x) TRUE else FALSE end};"
    program << "test(x)"
    eval(program).should be_true
    program =  "x = (4 == 4);"
    program << "test = fun(x) {if(x) TRUE else FALSE end};"
    program << "test(x)"
    eval(program).should be_true
  end

  it "should allow 'case' expressions with multiple 'when' and one 'else' branch" do
    program = <<-PROGRAM
    foo = fun(x) {
      case x
        when 1 then "one"
        when 2 then "two"
        when 3 then "three"
        else FALSE
      end
    };
    foo(2);
    PROGRAM
    eval(program).should == "two"

    program = <<-PROGRAM
    foo = fun(x) {
      case x
        when "foo" then "yes"
        when "bar" then "no"
        else FALSE
      end
    };
    foo("foo");
    PROGRAM
    eval(program).should == "yes"

    program = <<-PROGRAM
    foo = fun(x) {
      case x
        when "foo" then "yes"
        when "bar" then "no"
        else "something else"
      end
    };
    foo("hello");
    PROGRAM
    eval(program).should == "something else"

    program = <<-PROGRAM
    foo = fun(x) {
      case x
        when NULL then "nil"
        when 2 then "two"
        when 3 then "three"
        else FALSE
      end
    };
    foo(NULL);
    PROGRAM
    eval(program).should == "nil"

  end

  it "should allow multiple statements in each branch of a 'case' expression" do
    program = <<-PROGRAM
    foo = fun(x) {
      num = 0;
      name = case x
        when 1 then num = num + 1; "one"
        when 2 then num = num + 2; "two"
        when 3 then num = num + 3; "three"
        else FALSE
      end;
      [ num, name ]
    };
    foo(1);
    PROGRAM
    eval(program).should == [ 1, "one" ]
  end

end
