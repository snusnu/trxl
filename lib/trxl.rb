require "rubygems"
require "treetop"
require 'pathname'

dir = Pathname(__FILE__).dirname.expand_path + 'trxl'

require dir + 'trxl'
require dir + 'trxl_grammar'