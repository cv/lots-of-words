Gem::Specification.new do |s|
  s.name = %q{rest-client}
  s.version = "0.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Adam Wiggins"]
  s.date = %q{2008-10-13}
  s.default_executable = %q{restclient}
  s.description = %q{A simple REST client for Ruby, inspired by the Sinatra microframework style of specifying actions: get, put, post, delete.}
  s.email = %q{adam@heroku.com}
  s.executables = ["restclient"]
  s.files = ["Rakefile", "lib/resource.rb", "lib/rest_client.rb", "lib/request_errors.rb", "spec/resource_spec.rb", "spec/request_errors_spec.rb", "spec/rest_client_spec.rb", "spec/base.rb", "bin/restclient"]
  s.has_rdoc = true
  s.homepage = %q{http://rest-client.heroku.com/}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{rest-client}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{Simple REST client for Ruby, inspired by microframework syntax for specifying actions.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
    else
    end
  else
  end
end
