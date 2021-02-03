# frozen_string_literal: true

require_relative 'lib/peeky/version'

Gem::Specification.new do |spec|
  spec.name                   = 'peeky'
  spec.version                = Peeky::VERSION
  spec.authors                = ['David Cruwys']
  spec.email                  = ['david@ideasmen.com.au']

  spec.summary                = 'Take a peek into your ruby classes and extract useful meta data'
  spec.description            = 'peeky'
  spec.homepage               = 'http://appydave.com/gems/peeky'
  spec.license                = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")

  spec.metadata['allowed_push_host'] = "Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/klueless-io/peeky'
  spec.metadata['changelog_uri'] = 'https://github.com/klueless-io/peeky/commits/master'
  
  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the RubyGem files that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f| f.match(%r{^(test|spec|features)/}) end
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # spec.extensions    = ['ext/peeky/extconf.rb']
  spec.extra_rdoc_files = ['README.md', 'STORIES.md']
  spec.rdoc_options    += [
    '--title', 'peeky by appydave.com',
    '--main', 'README.md',
    '--files STORIES.MD USAGE.MD'
  ]

  spec.add_dependency 'activesupport'
end
