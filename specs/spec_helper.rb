require "rubygems"
require "treetop"
require "pathname"

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

SPEC_ROOT = Pathname(__FILE__).dirname.expand_path

require SPEC_ROOT.parent + 'lib/trxl'

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