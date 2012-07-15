lib = File.expand_path('../lib', __FILE__)
$:.unshift(lib) unless $:.include?(lib)

require 'gexf/version'

Gem::Specification.new do |s|
  s.name          = 'gexf'
  s.version       = GEXF::VERSION
  s.summary       = "GEXF Ruby library"
  s.description   = "A library for parsing, manipulating, and exporting graphs in the GEXF format."
  s.authors       = ["Andrea Fiore"]
  s.email         = 'andrea.giulio.fiore@gmail.com'
  s.homepage      = 'http://github.com/afiore/gexf.rb'

  s.rdoc_options  = ["--charset= UTF-8"]

  s.add_runtime_dependency('nokogiri', "~> 1.5.5")
  s.add_development_dependency('rspec', "~> 2.7.0")
  s.add_development_dependency('pry', "~> 0.9.10")
  s.add_development_dependency('rake', "~> 0.9.2.2")

  # = MANIFEST =

  s.files = (Dir['lib/**/*']).reject {|f| !File.file?(f) }
  s.test_files = (Dir['spec/**/*','.gitignore']).reject {|f| !File.file?(f) }
  #s.executables   = Dir['bin/*'].map { |f| File.basename(f) }
  s.require_paths = ['lib']
  # = MANIFEST =
end
