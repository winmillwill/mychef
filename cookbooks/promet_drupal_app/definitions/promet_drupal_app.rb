define :promet_drupal_app, :git_ref => 'master', :dump_path => false, :force => false, :drush_build => false do

  mysql_connection_info = {:host => "localhost", :username => 'root', :password => node['mysql']['server_root_password']}

  app_name = params[:name]

  repo_name = params[:repo_name] ? params[:repo_name] : "#{app_name}.prometdev.com"

  dump_path = params[:dump_path]

  drush_build = params[:drush_build]

  force = params[:force]

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

    # we always need this dir...
    create_dirs_before_symlink ["sites/default"]

    # we always need the settings file
    settings = {'settings.php' => 'sites/default/settings.php'}

    before_migrate do
      raise "wtf"
    end

    before_symlink do
      raise "wtf"
    end

    before_deploy do
      raise "wtf"
    end

    symlinks settings

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
      server_aliases ["#{app_name}.minode.com"]
    end

    # if we have a path to a dump, we must want to migrate
    if dump_path
      migrate true
      migration_command "drush sqlc < #{dump_path}"
      symlink_before_migrate settings
    end

    action force ? :force_deploy : :deploy
  end
  if dump_path
    log dump_path
  end
end

define :promet_deploy, :git_ref => 'master', :repo_name => false, :drush_build => false, :dump_path => false do

  app_name = params[:name]
  drush_build = params[:drush_build]
  repo_name = params[:repo_name] ? params[:repo_name] : "#{app_name}.prometdev.com"
  dump_path = params[:dump_path]
  drush_build = params[:drush_build]
  force = params[:force]

  directory '/tmp/nih_deploy'

  cookbook_file '/tmp/nih_deploy/nih-deploy-ssh-wrapper' do
    owner "wamilton"
    group "www-data"
    source 'nih-deploy-ssh-wrapper'
    mode 0700
  end

  if drush_build
    cookbook_file "/tmp/#{app_name}/#{drush_build}" do
      owner "wamilton"
      group "www-data"
      source drush_build
      mode 0700
    end
  end

  mysql_connection_info = {:host => "localhost", :username => 'root', :password => node['mysql']['server_root_password']}

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

  directory "/var/www/#{app_name}/shared" do
    owner 'wamilton'
    group 'www-data'
    mode '0755'
    recursive true
  end

  template "/var/www/#{app_name}/shared/settings.php" do
    source 'settings.php.erb'
    variables({
      :database => "#{app_name}DB",
      :user => "#{app_name}DBA",
      :pass => "#{app_name}PASS"
    })
  end

  promet = Chef::EncryptedDataBagItem.load("keys", "promet")
  deploy_key = promet['ssh']

  file '/tmp/nih_deploy/id_deploy' do
    owner "wamilton"
    group "www-data"
    content deploy_key
    mode 0700
  end

  deploy "/var/www/#{app_name}" do
    user "wamilton"
    group "www-data"

    repository "git@git.promethost.com:#{repo_name}"
    revision params[:git_ref]
    git_ssh_wrapper '/tmp/nih_deploy/nih-deploy-ssh-wrapper'
    symlinks({})
    # symlink_before_migrate({'settings.php' => 'sites/default/settings.php'})
    symlink_before_migrate({})

    before_migrate do
      current = release_path
    end
  end
end
