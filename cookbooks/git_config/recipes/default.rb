#
# Cookbook Name:: git_config
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

directory "/home/wamilton/.git_template" do
  owner "wamilton"
end

directory "/home/wamilton/.git_template/hooks" do
  owner "wamilton"
end

template "/home/wamilton/.git_template/hooks/ctags" do
  owner "wamilton"
  source 'ctags_init.sh.erb'
  mode '0755'
end

['post-commit', 'post-merge', 'post-checkout'].each do |hook|
  template "/home/wamilton/.git_template/hooks/#{hook}" do
    source 'most_hooks.sh.erb'
    owner "wamilton"
    mode '0755'
  end
end

# seems to try to lock the root git config...
#
# execute "git config --global init.templatedir '/home/wamilton/.git_template'" do
#   user "wamilton"
# end
