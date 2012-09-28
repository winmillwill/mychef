#
# Cookbook Name:: mutt
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

if platform?("ubuntu", "debian")
  package = "mutt-patched"
end

package "#{package}" do
  action :install
end
