Gem::Specification.new do |s|
  s.name = "myoack"
  s.version = File.read("VERSION")
  s.authors = ["pasberth"]
  s.description = %{Defaults on the authorization to scribbled script by My OAuth Consumer Key}
  s.summary = %q{first release}
  s.email = "pasberth@gmail.com"
  s.extra_rdoc_files = ["README.rdoc"]
  s.rdoc_options = ["--charset=UTF-8"]
  s.homepage = "http://github.com/pasberth/Myoack"
  s.require_paths = ["lib"]
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- spec/*`.split("\n")
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_dependency "sinatra"
  s.add_dependency "oauth"
  s.add_dependency "oauth2"
  s.add_dependency "multi_xml"
end