require "treetop"
require "#{File.dirname(__FILE__)}/../lib/trxl/trxl"

module Trxl
  
  module SpecHelper
  
    # raise unless successful
    def parse(expression)
      @parser.parse(expression)
    end

    # raise if an exception is raised during parsing
    # raise if an exception is raised during evaluation
    def eval(expression, env = Environment.new)
      env = Trxl::Environment.new(env) if env.is_a?(Hash)
      ast = parse(expression)
      ast.eval(env)
    end
  
  end
  
end