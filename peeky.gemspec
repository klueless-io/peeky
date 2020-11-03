# frozen_string_literal: true

require_relative 'lib/peeky/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version  = '>= 2.5'
  spec.name                   = 'peeky'
  spec.version                = Peeky::VERSION
  spec.authors                = ['David Cruwys']
  spec.email                  = ['david@ideasmen.com.au']

  spec.summary                = 'Extracting meta data from ruby classes'
  spec.description            = <<-TEXT
  Peeky is a Ruby GEM for peaking into ruby classes and extracting meta data.
  You can use this meta data to recreate classes, interfaces, documentation etc.
  or use it just to understand the internals of a class.
  TEXT

  spec.homepage               = 'http://appydave.com/gems/peeky'
  spec.license                = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.' unless spec.respond_to?(:metadata)

  # spec.metadata['allowed_push_host'] = "Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/klueless-io/peeky'
  spec.metadata['changelog_uri'] = 'https://github.com/klueless-io/peeky/commits/master'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the RubyGem files that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  # spec.extensions    = ['ext/peeky/extconf.rb']

  # spec.add_dependency 'tty-box',         '~> 0.5.0'
end
