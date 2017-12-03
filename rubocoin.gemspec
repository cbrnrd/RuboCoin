
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rubocoin"

Gem::Specification.new do |spec|
  spec.name          = "rubocoin"
  spec.version       = Rubocoin::VERSION
  spec.authors       = ["cbrnrd"]
  spec.email         = ["cbawsome77@gmail.com"]
  spec.executables   = %w[rubocoind]

  spec.summary       = ""
  spec.description   = ""
  spec.homepage      = ""
  spec.license       = "MIT"
  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end


  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_runtime_dependency "sinatra"
  spec.add_runtime_dependency "colorize"
end
