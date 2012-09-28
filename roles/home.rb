name 'home'
description 'configuration for workstations'
run_list (
  [
    'recipe[build-essential]',
    'recipe[ruby-shadow]',
    'recipe[tmux]',
    'recipe[vim]',
    'recipe[sudo]',
    'recipe[users::sysadmins]',
    'recipe[git]',
    'recipe[zsh]',
    'recipe[mutt]',
    'recipe[oh-my-zsh]',
    'recipe[fnichol-user::data_bag]',
    'recipe[nihmake]',
    'recipe[chef-dotfiles]',
    "recipe[nodejs]",
    "recipe[apache2]",
    "role[db_master]",
    "recipe[drush]",
    "recipe[ctags]",
    "recipe[git_config]",
    "recipe[airbox]"
  ]
)
default_attributes "authorization" => {"sudo" => {"groups" => ["sysadmin"], "passwordless" => true}}
