#
# Cookbook Name:: drupal_application
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

app_name = 'drupal'

application app_name do
  path "/var/www/#{app_name}"
  owner "wamilton"
  group "www-data"

  repository "http://git.drupal.org/project/drupal.git"

  # we always need this dir...
  create_dirs_before_symlink ["sites/default"]

  # we always need the settings file
  settings = {'settings.php' => 'sites/default/settings.php'}
  symlinks settings

  migrate true
  migration_command "drush sqlc < #{dump_path}"
  symlink_before_migrate settings

  before_migrate do
    raise "wtf"
  end

  before_symlink do
    raise "wtf"
  end

  before_deploy do
    raise "wtf"
  end

  before_compile do
    raise "wtf"
  end

  php do
    database do
      database "#{app_name}DB"
      user "#{app_name}DBA"
      pass "#{app_name}PASS"
    end
    local_settings_file 'settings.php'
  end

  mod_php_apache2 do
    webapp_template "php.conf.erb"
  end
end
