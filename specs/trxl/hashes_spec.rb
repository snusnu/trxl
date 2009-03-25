require "#{File.dirname(__FILE__)}/../spec_helper"

describe "For working with Hashes, the Trxl::Calculator" do

  include Trxl::SpecHelper
  
  before(:each) do
    @parser = Trxl::Calculator.new
  end


  it "should evaluate hash literal expressions" do
    eval("{}").should == {}
    eval("{ 1 => 2 }").should == { 1 => 2 }
    eval("{ 1 => 2, 3 => 4 }").should == { 1 => 2, 3 => 4 }
  end

  it "should allow hash variable definitions" do
    eval("a = {}").should == {}
    eval("a = {}; a;").should == {}
    eval("a = { 1 => 2 }").should == { 1 => 2 }
    eval("a = { 1 => 2 }; a;").should == { 1 => 2 }
    eval("a = { 1 => 2, 3 => 4 }; a;").should == { 1 => 2, 3 => 4 }
  end

  it "should allow nested hash variable definitions" do
    eval("a = { 1 => { 2 => 3 } }").should == { 1 => { 2 => 3 } }
    eval("a = { 1 => { 2 => 3 }, 4 => 5 }").should == { 1 => { 2 => 3 }, 4 => 5 }
  end

  it "should allow arbitrary expressions in hash literal" do
    eval("x = 1; foo = fun(x) {x}; h = { fun(){2}() => foo(3) }").should == { 2 => 3 }
  end
  
  it "should be able to index hashes by their keys" do
    eval("h = { 1 => 2 }; h[0]").should == nil
    eval("h = { 1 => 2 }; h[1]").should == 2
    eval("h = { 1 => 2 }; h[2]").should == nil
  end

  it "should recognize primary expressions as hash offset specifiers" do
    eval("h = { 1 => 2 }; h[fun(x){x}(0)]").should == nil
    eval("h = { 1 => 2 }; h[fun(x){x}(1)]").should == 2
    eval("h = { 1 => 2 }; h[fun(x){x}(2)]").should == nil
  end
  
  it "should resolve exact matching expressions" do
    env = { :foo => { :a => "bar", :b => "bar", :c => "baz" } }
    eval("foo[='bar']", env).should == [ [:a, "bar"], [:b, "bar"] ]
    eval("foo[='baz']", env).should == [ [:c, "baz"] ]
    eval("foo[='bam']", env).should == []
  end

  it "should resolve exact matching expressions followed by offset access expressions" do
    env = { :foo => { :a => "bar", :b => "bar", :c => "baz" } }
    eval("foo[='bar'][0]", env).should == [ :a, "bar" ]
    eval("foo[='bar'][1]", env).should == [ :b, "bar" ]
    eval("foo[='baz'][0]", env).should == [ :c, "baz" ]
    eval("foo[='bam'][0]", env).should be_nil
  end

end
