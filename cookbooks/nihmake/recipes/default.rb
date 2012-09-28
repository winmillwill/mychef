#
# Cookbook Name:: nihmake
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

application "nih_make" do
  path "/var/www/nih"
  owner "wamilton"
  group "www-data"

  repository "ssh://promet_git/nih.prometdev.com"
  revision "make.1"
  promet = Chef::EncryptedDataBagItem.load("keys", "promet")
  deploy_key promet['ssh']
end
