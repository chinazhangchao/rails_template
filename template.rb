require 'fileutils'

route "root to: 'home#index'"

src_dir = File.expand_path("../", __FILE__) + '/'

FileUtils.mkdir_p("vendor/assets/stylesheets/")
FileUtils.mkdir_p("vendor/assets/javascripts/")

FileUtils.cp("#{src_dir}Gemfile", "./")

FileUtils.cp("#{src_dir}.env", "./")
FileUtils.cp("#{src_dir}.env.production", "./")
FileUtils.cp("#{src_dir}.gitignore", "./")
FileUtils.cp("#{src_dir}.rubocop.yml", "./")
FileUtils.cp("#{src_dir}bg_dev.sh", "./")
FileUtils.cp("#{src_dir}bg_test.sh", "./")
FileUtils.cp("#{src_dir}bg_production.sh", "./")
FileUtils.cp("#{src_dir}debug.sh", "./")
FileUtils.cp("#{src_dir}test.sh", "./")
FileUtils.cp("#{src_dir}production.sh", "./")
FileUtils.cp("#{src_dir}preconfig.sh", "./")
FileUtils.cp("#{src_dir}restart_bg_dev.sh", "./")
FileUtils.cp("#{src_dir}restart_bg_production.sh", "./")
FileUtils.cp("#{src_dir}restart_bg_test.sh", "./")
FileUtils.cp("#{src_dir}stop_server.sh", "./")
FileUtils.cp("#{src_dir}check_code.sh", "./")
FileUtils.cp("#{src_dir}compile_assets.sh", "./")
FileUtils.cp_r("#{src_dir}kaminari", "app/views/")
FileUtils.cp_r("#{src_dir}devise", "app/views/")
FileUtils.cp("#{src_dir}application.js", "app/assets/javascripts/")
FileUtils.cp("#{src_dir}application.css", "app/assets/stylesheets/")
FileUtils.cp("#{src_dir}application.html.erb", "app/views/layouts/")
FileUtils.cp("#{src_dir}session.html.erb", "app/views/layouts/")
FileUtils.cp("#{src_dir}my_base_devise_controller.rb", "app/controllers/")
FileUtils.cp("#{src_dir}devise.rb", "config/initializers/")
FileUtils.cp("#{src_dir}application.rb", "config/")
FileUtils.cp("#{src_dir}zh-CN.yml", "config/locales/")
FileUtils.cp("#{src_dir}rails.zh-CN.yml", "config/locales/")
FileUtils.cp("#{src_dir}devise.zh-CN.yml", "config/locales/")

run "bundle install"

run "yarn add semantic-ui --ignore-scripts"
run "yarn add jquery"

generate(:controller, "home", "index", "--no-helper", "--no-assets", "--skip-routes")
