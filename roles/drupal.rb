name 'drupal'
description 'configuration for drupal needs'
run_list (
  [
    "recipe[apache2]",
    "role[db_master]",
    "recipe[drush]",
    "recipe[promet_drupal_app]"
  ]
)
