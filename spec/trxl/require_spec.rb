require 'spec_helper'

describe "For defining Trxl::StdLib, the Trxl::Calculator" do
  
  include Trxl::SpecHelper
  
  before(:each) do
    @parser = Trxl::Calculator.new
  end
  
  it "should be able to require trxl code snippets and merge them into the current env" do
    program = "require 'stdlib'"
    env_after_require = eval(program)
    env_after_require.should have_key(:foreach_in)
    env_after_require.should have_key(:_foreach_in_)
    env_after_require.should have_key(:inject)
    env_after_require.should have_key(:_inject_)
    env_after_require.should have_key(:map)
    env_after_require.should have_key(:ratio)
  end
  
  it "should be able to require scoped trxl code snippets and merge them into the current env" do
    program = "require 'stdlib/foreach_in'"
    env_after_require = eval(program)
    env_after_require.should have_key(:foreach_in)
    
    program = "require 'stdlib/inject'"
    env_after_require = eval(program)
    env_after_require.should have_key(:inject)
  end
  
  it "should be able to require scoped trxl code snippets and merge them into the current env" do
    program = "require 'stdlib/foreach_in'"
    env_after_require = eval(program)
    env_after_require.should have_key(:foreach_in)
    
    program = "require 'stdlib/inject'"
    env_after_require = eval(program)
    env_after_require.should have_key(:inject)
  end
  
  it "should ignore a require statement if the library has already been loaded" do
    program = "require 'stdlib/inject'"
    program = "require 'stdlib/map'"
    env_after_require = eval(program)
    env_after_require.should have_key(:inject)
    env_after_require.should have_key(:map)
  end
  
end
