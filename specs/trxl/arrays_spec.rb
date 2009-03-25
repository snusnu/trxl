require "#{File.dirname(__FILE__)}/../spec_helper"

describe "For working with Arrays, the language" do

  include Trxl::SpecHelper
  
  before(:each) do
    @parser = Trxl::Calculator.new
  end

  
  it "should resolve positive offsets within arrays" do
    env = { :foo => [ 1, 2, 3 ] }
    eval("foo[0]", env).should == 1
    eval("foo[1]", env).should == 2
    eval("foo[2]", env).should == 3
    eval("foo[3]", env).should be_nil
  end

  it "should recognize primary expressions as offset specifiers" do
    env = { :foo => [ 1, 2, 3 ] }
    eval("a = 0; foo[a]", env).should == 1
    eval("foo[fun(x){x}(0)]", env).should == 1
  end
  
  it "should resolve negative offsets within arrays" do
    env = { :foo => [ 1, 2, 3 ] }
    eval("foo[-1]", env).should == 3
    eval("foo[-2]", env).should == 2
    eval("foo[-3]", env).should == 1
    eval("foo[-4]", env).should be_nil
  end

  it "should resolve exact matching expressions" do
    env = { :foo => [ 1, 2, 2, 3, 3, 3 ] }
    
    eval("foo[=1]", env).should == [1]
    eval("foo[=2]", env).should == [2,2]
    eval("foo[=3]", env).should == [3,3,3]
    eval("foo[=4]", env).should == []

    env = { :foo => [ "foo", "foo", "bar" ] }
    
    eval("foo[='foo']", env).should == [ "foo", "foo" ]
    eval("foo[='bar']", env).should == [ "bar" ]
    eval("foo[='baz']", env).should == []

    env = { :foo => [ "foo", "foo", "bar" ], :a => "foo", :b => "bar", :c => "baz" }
    
    eval("foo[=a]", env).should == [ "foo", "foo" ]
    eval("foo[=b]", env).should == [ "bar" ]
    eval("foo[=c]", env).should == []
  end

  it "should resolve exact matching expressions followed by offset access expressions" do
    env = { :foo => [ 1, 2, 2, 3, 3, 3 ] }
    eval("foo[=1][0]", env).should == 1
    eval("foo[=2][0]", env).should == 2
    eval("foo[=2][1]", env).should == 2
    eval("foo[=3][0]", env).should == 3
    eval("foo[=3][1]", env).should == 3
    eval("foo[=3][2]", env).should == 3
    eval("foo[=4][0]", env).should be_nil
  end

  it "should allow array variable definitions" do
    eval("a = []").should == []
    eval("a = []; a;").should == []
    eval("a = [ 1, 2, 3 ]").should == [ 1, 2, 3 ]
    eval("a = [ 1, 2, 3 ]; a;").should == [ 1, 2, 3 ]
  end

  it "should allow nested array variable definitions" do
    eval("a = [[]]").should == [[]]
    eval("a = [[]]; a;").should == [[]]
    eval("a = [ [1, 2], [3, 4] ]").should == [ [1, 2], [3, 4] ]
    eval("a = [ [1, 2], [3, 4] ]; a;").should == [ [1, 2], [3, 4] ]
  end

  it "should allow arbitrary expressions in array literal" do
    eval("x = 1; foo = fun(x) {x}; arr = [ x, fun(){2}(), foo(3) ]").should == [ 1, 2, 3 ]
  end

  it "should be able to perform offset access expressions on user defined array variables" do
    eval("a = [1,2,3]; a[0]").should == 1
    eval("a = [1,2,3]; a[1]").should == 2
    eval("a = [1,2,3]; a[2]").should == 3
    
    eval("a = []; a[0]").should be_nil
    eval("a = [[]]; a[0]").should == []
  end

  it "should be able to perform multiple offset access expressions on nested array variables" do
    eval("a = [[]][0]").should == []
    eval("a = [ [1, 2], [3, 4] ]; a[0]").should == [1, 2]
    eval("a = [ [1, 2], [3, 4] ]; a[0][0];").should == 1
    eval("a = [ [1, 2], [3, 4] ]; a[0][1];").should == 2
  end

  it "should return arrays for array literal expressions" do
    eval("[1,2,3]").should == [ 1, 2, 3 ]
    eval("[ 1, fun(){2}(), fun(x){x}(3) ]").should == [ 1, 2, 3 ]
  end

  it "should be able to perform offset access expressions on array literals" do
    eval("[1,2,3][0]").should == 1
    eval("[1,2,3][1]").should == 2
    eval("[1,2,3][2]").should == 3
    eval("[1,2,3][-1]").should == 3
    eval("[1,2,3][-2]").should == 2
    eval("[1,2,3][-3]").should == 1
  end

  it "should be able to calculate the size of any given Array or String" do
    eval("a = [ 1, 2, 3 ]; SIZE(a);").should == 3
    eval("SIZE(a = [ 1, 2, 3 ])").should == 3
    eval("SIZE([ 1, 2, 3 ])").should == 3
    
    eval("s = 'Test String'; SIZE(s);").should == "Test String".size
    eval("SIZE(a = 'Test String')").should == "Test String".size
    eval("SIZE('Test String')").should == "Test String".size
    
    lambda { eval("SIZE(1)") }.should raise_error(Trxl::InvalidOperationException)
    lambda { eval("SIZE(fun(){3}())") }.should raise_error(Trxl::InvalidOperationException)
  end
  
  it "should allow to push values into an already existing Array" do
    eval("a = []; a << 1;").should == [ 1 ]
    eval("a = []; a << 1; a;").should == [ 1 ]
    eval("a = [1]; a << 2;").should == [ 1, 2 ]
    eval("a = [1]; a << 2; a;").should == [ 1, 2 ]
    lambda { eval("a = 1; a << 2;") }.should raise_error(Trxl::InvalidOperationException)

    #eval("a = [[]]; a[0] << 1;").should == [ [1] ]
    eval("a = [[]]; a[0] << 1; a;").should == [ [1] ]
    eval("a = [1]; a << [2];").should == [ 1, [ 2 ] ]
    eval("a = [1]; a << [2]; a;").should == [ 1, [ 2 ] ]
    lambda { eval("a = [1]; a[0] << 2;") }.should raise_error(Trxl::InvalidOperationException)
  end
  
  it "should allow to add two Arrays" do
    eval("[1,2,3] + []").should == [1,2,3]
    eval("[] + [4,5,6]").should == [4,5,6]
    eval("[1,2,3] + [4,5,6]").should == [1,2,3,4,5,6]

    eval("[[1,2],3] + []").should == [[1,2],3]
    eval("[[]] + [4,5,6]").should == [[],4,5,6]
    eval("[[1,2],3] + [[4,5],6]").should == [[1,2],3,[4,5],6]
  end
  
  it "should allow to subtract two Arrays" do
    eval("[1,2,3] - []").should == [1,2,3]
    eval("[] - [4,5,6]").should == []
    eval("[1,2,3] - [4,5,6]").should == [1,2,3]
    eval("[1,2,3,4,5,6] - [4,5,6]").should == [1,2,3]

    eval("[[1,2],3] - []").should == [[1,2],3]
    eval("[[]] - [4,5,6]").should == [[]]
    eval("[[1,2],3] - [4,5,6]").should == [[1,2],3]
    eval("[1,2,3,[4],5,[6]] - [4,5,6]").should == [1,2,3,[4],[6]]
  end

end
