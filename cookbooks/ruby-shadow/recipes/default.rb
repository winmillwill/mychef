if File.exist?("/opt/chef/")

  package "gcc" do
    action :install
  end

  execute "installMongrelPre" do
    command "/opt/chef/embedded/bin/gem install mongrel --pre"
    creates "/opt/chef/embedded/lib/ruby/gems/1.9.1/gems/mongrel-1.2.0.pre2/setup.rb"
    action :run
  end

  gem_package "ruby-shadow" do
    gem_binary  "/opt/chef/embedded/bin/gem"
    action :install
  end

else

  gem_package "ruby-shadow" do
    action :install
  end
end
