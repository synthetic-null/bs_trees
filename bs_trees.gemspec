# frozen_string_literal: true

require_relative 'lib/bs_trees/version'

Gem::Specification.new do |spec|
  spec.name                  = 'bs_trees'
  spec.version               = BSTrees::VERSION
  spec.authors               = ['Roman Kozachenko']
  spec.email                 = ['romkozachenko@gmail.com']

  spec.summary               = <<~SUMMARY
    Implementation of binary search and AVL trees by pure Ruby.
  SUMMARY

  spec.homepage              = 'https://github.com/synthetic-null/bs_trees'
  spec.license               = 'WTFPL'
  spec.required_ruby_version = '>= 3.2.0'

  spec.metadata['homepage_uri']    = spec.homepage
  spec.metadata['source_code_uri'] = "#{spec.homepage}/tree/main"
  spec.metadata['changelog_uri']   = "#{spec.homepage}/blob/main/CHANGELOG.md"

  gemspec = File.basename(__FILE__)

  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
end
