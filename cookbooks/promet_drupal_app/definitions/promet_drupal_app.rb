define :promet_drupal_app, :git_ref => 'master' do

  mysql_connection_info = {:host => "localhost", :username => 'root', :password => node['mysql']['server_root_password']}

  app_name = params[:name]

  repo_name = params[:repo_name] ? params[:repo_name] : "#{app_name}.prometdev.com"

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

    repository "git@git.promethost.com:#{repo_name}"
    revision params[:git_ref]
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
    migration_command 'drush updb'
  end

end
