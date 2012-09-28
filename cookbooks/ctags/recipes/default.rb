#
# Cookbook Name:: ctags
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

if platform?("ubuntu", "debian")
  package "exuberant-ctags"
else
  package "ctags"
end
