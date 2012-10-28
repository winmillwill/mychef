name 'home'
description 'configuration for workstations'
run_list (
  [
    'recipe[build-essential]',
    'recipe[ruby-shadow]',
    'recipe[tmux]',
    'recipe[sudo]',
    'recipe[users::sysadmins]',
    'recipe[git]',
    'recipe[zsh]',
    'recipe[mutt]',
    'recipe[oh-my-zsh]',
    'recipe[fnichol-user::data_bag]',
    'recipe[chef-dotfiles]',
    "recipe[ctags]",
    "recipe[git_config]",
    "recipe[emacs]",
    "recipe[rvm::user]",
    "role[drupal]"
  ]
)
default_attributes "authorization" => {"sudo" => {"groups" => ["sysadmin"], "passwordless" => true}}
