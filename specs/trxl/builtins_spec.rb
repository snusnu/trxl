require "#{File.dirname(__FILE__)}/../spec_helper"

describe "The language" do

  include Trxl::SpecHelper
  
  before(:each) do
    @parser = Trxl::Calculator.new
  end
  
  it "should allow to access the current environment by calling ENV" do
    env = eval("ENV", {})
    env.should be_kind_of(Trxl::Environment)
    env.should be_empty
    
    env = eval("ENV", { :a => 1, :b => 2 })
    env.should be_kind_of(Trxl::Environment)
    env.should have_key(:a)
    env.should have_key(:b)
    env[:a].should == 1
    env[:b].should == 2
  end

  it "should allow to access variables by name by calling ENV['foo']" do
    eval("ENV['a']", {}).should == nil
    eval("ENV['a']", { :a => 1 }).should == 1
    eval("ENV['a']", { :a => "yes" }).should == "yes"
    eval("ENV['a']", { :a => [ 1, 2, 3 ] }).should == [ 1, 2, 3 ]
  end

  it "should allow to access ranges in the current environment by calling ENV['a'..'z']" do
    eval("ENV['a'..'a']", { :a => 1, :b => 2, :c => 3 }).should == [ 1 ]
    eval("ENV['a'..'b']", { :a => 1, :b => 2, :c => 3 }).should include(1)
    eval("ENV['a'..'b']", { :a => 1, :b => 2, :c => 3 }).should include(2)
    eval("ENV['a'..'c']", { :a => 1, :b => 2, :c => 3 }).should include(1)
    eval("ENV['a'..'c']", { :a => 1, :b => 2, :c => 3 }).should include(2)
    eval("ENV['a'..'c']", { :a => 1, :b => 2, :c => 3 }).should include(3)
  end
  
  it "should be able to PRINT and PRINT_LINE to STDOUT" do
    eval("PRINT('- This is output from PRINT. ')").should be_nil
    eval("PRINT_LINE('And this is output from PRINT_LINE')").should be_nil
  end
  
  it "should be able to split strings by calling SPLIT(some_string, split_char)" do
    eval("SPLIT('foo/bar', '/')").should == [ 'foo', 'bar' ]
  end
  
  it "should be able to convert values into integers by calling TO_INT(alpha_numeric_string)" do
    eval("TO_INT('1')").should == 1
  end
  
  it "should be able to convert values into floats by calling TO_FLOAT(alpha_numeric_string)" do
    eval("TO_FLOAT('1.12')").should == 1.12
  end
  
  it "should be able to convert values into arrays by calling TO_ARRAY(some_value)" do
    eval("TO_ARRAY(1)").should == [ 1 ]
    eval("TO_ARRAY('1')").should == [ '1' ]
    eval("TO_ARRAY([1])").should == [ 1 ]
    eval("TO_ARRAY({ 1 => 2 })").should == [ [1, 2] ]
    eval("TO_ARRAY({ 1 => 2, 3 => 4 })").should == [ [1, 2], [3, 4] ]
  end

  it "should be able to round numbers to a given number of decimal places by calling ROUND(num, digits)" do
    program =  "ROUND(1.2222,0)"
    eval(program).should == 1
    program =  "ROUND(1.6666,0)"
    eval(program).should == 2
    program =  "ROUND(1.2222,1)"
    eval(program).should == 1.2
    program =  "ROUND(1.2222,2)"
    eval(program).should == 1.22
    program =  "ROUND(1.2782,2)"
    eval(program).should == 1.28
    program =  "ROUND(fun(){1.1234567}(),4)"
    eval(program).should == 1.1235
    program =  "ROUND(NULL,2)"
    eval(program).should be_nil
    program =  "ROUND(FALSE,2)"
    eval(program).should be_nil
    program =  "ROUND(TRUE,2)"
    eval(program).should be_nil
  end

  it "should be able to calculate SUM for an arbitrary number of argument expressions" do
    program = "SUM()"
    eval(program).should == 0
    program = "SUM(NULL)"
    eval(program).should == 0
    program = "SUM(0)"
    eval(program).should == 0
    program = "SUM(1)"
    eval(program).should == 1
    program = "SUM(1,2,3,4)"
    eval(program).should == 10
    program = "SUM(1,2,3,NULL)"
    eval(program).should == 6
    program = "SUM(fun(){4}(),fun(x){x}(4),fun(x,y){x+y}(2,2))"
    eval(program).should == 12
    program = "SUM(x)"
    eval(program, { :x => [ 1, 2, 3 ] }).should == 6
    
    program =  "SUM([2,2,2],[4,4,4],[3,3,3])"
    eval(program).should == 27
    
    program =  "SUM([ [2,2,2], [4,4,4], [3,3,3] ])"
    eval(program).should == 27
  end
  
  it "should be able to calculate MULT for an arbitrary number of argument expressions" do
    program =  "MULT()"
    eval(program).should == 0
    program =  "MULT(NULL)"
    eval(program).should == 0
    program =  "MULT(0)"
    eval(program).should == 0
    program =  "MULT(1)"
    eval(program).should == 1
    program =  "MULT(1,2,3,4)"
    eval(program).should == 24
    program =  "MULT(1,2,3,NULL)"
    eval(program).should == 6
    program =  "MULT(fun(){4}(),fun(x){x}(4),fun(x,y){x+y}(2,2))"
    eval(program).should == 64
    program = "MULT(x)"
    eval(program, { :x => [ 1, 2, 3 ] }).should == 6
  end
  
  it "should be able to calculate AVG for an arbitrary number of argument expressions" do
    program =  "AVG()"
    eval(program).should == 0
    program =  "AVG(NULL)"
    eval(program).should be_nil
    program =  "AVG(0)"
    eval(program).should == 0
    program =  "AVG(1)"
    eval(program).should == 1
    program =  "AVG(3,3,3)"
    eval(program).should == 3
    program =  "AVG(3,3,3)"
    eval(program).should == 3
    program =  "AVG(3,5,0)"
    eval(program).should be_close(2.66666666666, 0.01)
    program =  "AVG(FALSE, 3,5,0)"
    eval(program).should == 4
    program =  "AVG(TRUE, 3,5,0)"
    eval(program).should be_close(2.66666666666, 0.01)
    program =  "AVG(3,NULL,3)"
    eval(program).should == 3
    program =  "AVG(3.3,3.3,3.3)"
    eval(program).should be_close(3.3, 0.01)
    program =  "AVG(3,5,4)"
    eval(program).should == 4
    program =  "AVG(fun(){4}(),fun(x){x}(4),fun(x,y){x+y}(2,2))"
    eval(program).should == 4
    
    program =  "AVG([1,2,3],[4,4,4],[6,6,6])"
    eval(program).should == 4
    program =  "AVG([2,2],[4,4,4],[6,6])"
    eval(program).should == 4
  end
  
  it "should be able to calculate AVG_SUM for an arbitrary number of argument expressions" do
    program =  "AVG_SUM([1,2,3],[4,4,4],[6,6,6])"
    eval(program).should == 12
    program =  "AVG_SUM([2,2],[4,4,4],[6,6])"
    eval(program).should == 12
    
    env = {
      :ap => [138542.0, 136795.0, 134256.0], # 136531
      :aq => [124580.0, 21458.0, 34560.0],   #  60199.3333333333
      :ar => [1200.0, 1200.0, 1200.0],       #   1200
      :as => [1235.0, 1265.0, 5620.0],       #   2706.66666666667
      :at => [5201.0, 4263.0, 8452.0],       #   5972
      :au => [250.0, 250.0, 250.0]           #    250
                                             # ------------------
                                             # 206859
                                             
    }
    eval("AVG_SUM(ENV['ap'..'au'])", env).should == 206859
    
    env = {
      :ap => [138542.0, 136795.0, 134256.0], # 136531
      :aq => [124580.0, 21458.0, 34560.0],   #  60199.3333333333
      :ar => [1200.0, 1200.0, 1200.0],       #   1200
      :as => [1235.0, 1265.0, 5620.0],       #   2706.66666666667
      :at => [5201.0, 4263.0, 8452.0],       #   5972
      :au => [0, 0, 0]                       #      0
                                             # ------------------
                                             # 206609
                                             
    }
    eval("AVG_SUM(ENV['ap'..'au'])", env).should == 206609
    
  end

  it "should be able to calculate MIN for an arbitrary number of argument expressions" do
    program =  "MIN()"
    eval(program).should == 0
    program =  "MIN(0)"
    eval(program).should == 0
    program =  "MIN(1)"
    eval(program).should == 1
    program =  "MIN(1,2,3)"
    eval(program).should == 1
    program =  "MIN(1.0, 2.0, 3.0)"
    eval(program).should == 1.0
    program =  "MIN(fun(){4}(),fun(x){x}(4),fun(x,y){x+y}(2,2))"
    eval(program).should == 4
  end

  it "should be able to calculate MAX for an arbitrary number of argument expressions" do
    program =  "MAX()"
    eval(program).should == 0
    program =  "MAX(0)"
    eval(program).should == 0
    program =  "MAX(1)"
    eval(program).should == 1
    program =  "MAX(1,2,3)"
    eval(program).should == 3
    program =  "MAX(1.0, 2.0, 3.0)"
    eval(program).should == 3.0
    program =  "MAX(fun(){4}(),fun(x){x}(4),fun(x,y){x+y}(2,2))"
    eval(program).should == 4
  end
  
  it "should be able to map all hash ids that match a given value by calling MATCHING_IDS" do
    env = { :foo => { :a => "bar", :b => "bar", :c => "baz" } }
    eval("MATCHING_IDS('bar', foo)", env).should include(:a)
    eval("MATCHING_IDS('bar', foo)", env).should include(:b)
    eval("MATCHING_IDS('baz', foo)", env).should == [ :c ]
    eval("MATCHING_IDS('bam', foo)", env).should == []
  end
  
  it "should define a VALUES_OF_TYPE function" do
    env = { 
      :all_types => { :a => "bar", :b => "bar", :c => "baz" },
      :all_values => { :a => 100, :b => 200, :c => 300 }
    }
    eval("VALUES_OF_TYPE('bar', all_types, all_values)", env).should include(100)
    eval("VALUES_OF_TYPE('bar', all_types, all_values)", env).should include(200)
    eval("VALUES_OF_TYPE('baz', all_types, all_values)", env).should == [ 300 ]
    eval("VALUES_OF_TYPE('bam', all_types, all_values)", env).should == []

    env = { 
      :all_types => { :a => "bar", :b => "bar", :c => "baz" },
      :all_values => { :a => [100,200,300], :b => [400,500,600], :c => [700,800,900] }
    }
    eval("VALUES_OF_TYPE('bar', all_types, all_values)", env).should include([100,200,300])
    eval("VALUES_OF_TYPE('bar', all_types, all_values)", env).should include([400,500,600])
    eval("VALUES_OF_TYPE('baz', all_types, all_values)", env).should == [ [700,800,900] ]
    eval("VALUES_OF_TYPE('bam', all_types, all_values)", env).should == []

    env = { 
      :all_types => { :a => "bar", :b => "bar", :c => "baz" },
      :all_values => []
    }
    lambda { eval("VALUES_OF_TYPE('bar', all_types, all_values)", env) }.should raise_error(Trxl::InvalidArgumentException)
    
    env = { 
      :all_types => [],
      :all_values => { :a => [100,200,300], :b => [400,500,600], :c => [700,800,900] }
    }
    lambda { eval("VALUES_OF_TYPE('bar', all_types, all_values)", env) }.should raise_error(Trxl::InvalidArgumentException)
  end
  
end
