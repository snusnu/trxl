# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{trxl}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["snusnu"]
  s.date = %q{2009-07-11}
  s.email = %q{ma@zive.at}
  s.extra_rdoc_files = [
    "README"
  ]
  s.files = [
    ".gitignore",
     "README",
     "Rakefile",
     "VERSION",
     "lib/trxl/trxl.rb",
     "lib/trxl/trxl_grammar.rb",
     "lib/trxl/trxl_grammar.treetop",
     "specs/spec_helper.rb",
     "specs/trxl/arithmetics_spec.rb",
     "specs/trxl/arrays_spec.rb",
     "specs/trxl/booleans_spec.rb",
     "specs/trxl/builtins_spec.rb",
     "specs/trxl/closures_spec.rb",
     "specs/trxl/comments_spec.rb",
     "specs/trxl/common_spec.rb",
     "specs/trxl/conditionals_spec.rb",
     "specs/trxl/constants_spec.rb",
     "specs/trxl/environment_spec.rb",
     "specs/trxl/examples_spec.rb",
     "specs/trxl/hashes_spec.rb",
     "specs/trxl/numbers_spec.rb",
     "specs/trxl/ranges_spec.rb",
     "specs/trxl/require_spec.rb",
     "specs/trxl/stdlib_spec.rb",
     "specs/trxl/strings_spec.rb",
     "specs/trxl/variables_spec.rb",
     "trxl.gemspec"
  ]
  s.homepage = %q{http://github.com/snusnu/trxl}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{TODO}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
