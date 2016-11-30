# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'handy_toolbox/version'

Gem::Specification.new do |spec|
  spec.name          = "handy_toolbox"
  spec.version       = HandyToolbox::VERSION
  spec.authors       = ["Bartłomiej Wójtowicz"]
  spec.email         = ["wojtowicz.bartlomiej@gmail.com"]

  spec.summary       = %q{Task manager without the need of typing}
  spec.description   = <<-DESC
HandyToolbox is a text based user interface that will help you with every day tasks.
Define your tasks and organize them into groups.'
And from now on you can forget all rake, capistrano, heroku, npm, ... commands.
  DESC
  spec.homepage      = "https://github.com/qbart/handy_toolbox"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "curses"

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
end
