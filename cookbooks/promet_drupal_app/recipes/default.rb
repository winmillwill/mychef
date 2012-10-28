#
# Cookbook Name:: promet_drupal_app
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

promet_drupal_app "airbox"
promet_drupal_app "crs"

promet_drupal_app "nih" do
  git_ref 'promet'
end

promet_drupal_app "ldaptest" do
  git_ref 'promet'
end

# promet_deploy "nih_deploy" do
#   repo_name 'nih.prometdev.com'
#   reference 'promet'
#   drush_build 'nih-drush-build'
# end
