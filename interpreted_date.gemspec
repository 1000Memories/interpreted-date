# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'interpreted_date/version'

Gem::Specification.new do |gem|
  gem.name          = "interpreted_date"
  gem.version       = InterpretedDate::VERSION
  gem.authors       = ["Brett Huneycutt"]
  gem.email         = ["brett@1000memories.com"]
  gem.description   = %q{Human readable dates from incomplete dates}
  gem.summary       = %q{Provide one, some or all of decade, year, month and day and get back a human readable date.}
  gem.homepage      = ""

  gem.add_development_dependency "rspec"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
