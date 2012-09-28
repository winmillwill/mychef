name 'db_master'
description 'for servers that are db masters'
run_list (
  [
    'recipe[mysql::server]',
    'recipe[mysql::ruby]',
    'recipe[database]'
  ]
)
