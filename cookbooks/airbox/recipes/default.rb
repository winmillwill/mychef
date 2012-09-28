#
# Cookbook Name:: airbox
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

mysql_connection_info = {:host => "localhost", :username => 'root', :password => node['mysql']['server_root_password']}

app_name = 'airbox'

  mysql_database_user "#{app_name}DBA" do
    connection mysql_connection_info
    password "#{app_name}PASS"
    action :create
  end

  mysql_database "#{app_name}DB" do
    connection mysql_connection_info
    action :create
  end

  mysql_database_user "#{app_name}DBA" do
    connection mysql_connection_info
    database_name "#{app_name}DB"
    password "#{app_name}PASS"
    action :grant
  end

application app_name do
  path "/var/www/#{app_name}"
  owner "wamilton"
  group "www-data"

  repository "ssh://promet_git/airbox.prometdev.com"
  revision "master"
  promet = Chef::EncryptedDataBagItem.load("keys", "promet")
  deploy_key promet['ssh']

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

  symlink_before_migrate({
    'settings.php' => 'sites/default/settings.php'
  })
  before_migrate {|wtf|
  }
    # get db
  migration_command 'drush updb'

  # TODO: figure out how the pros set action for on-offs.
  action :force_deploy
end
