require "rubygems"
require "treetop"
require 'pathname'

dir = Pathname(__FILE__).dirname.expand_path + 'trxl'

Treetop.load dir.to_s + "/trxl_grammar"
require dir + 'trxl'
require dir + 'trxl_grammar'