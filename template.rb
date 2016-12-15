require 'fileutils'

route "root to: 'home#index'"

src_dir = File.expand_path("../", __FILE__) + '/'

FileUtils.cp("#{src_dir}Gemfile", "./")

FileUtils.cp("#{src_dir}.env.production", "./")
FileUtils.cp("#{src_dir}.gitignore", "./")
FileUtils.cp("#{src_dir}.rubocop.yml", "./")
FileUtils.cp("#{src_dir}check_code.sh", "./")
FileUtils.cp("#{src_dir}compile_assets.sh", "./")
FileUtils.cp("#{src_dir}semantic.scss", "vendor/assets/stylesheets/")
FileUtils.cp("#{src_dir}jquery.form.js", "vendor/assets/javascripts/")
FileUtils.cp_r("#{src_dir}kaminari", "app/views/")
FileUtils.cp("#{src_dir}application.js", "app/assets/javascripts/")
FileUtils.cp("#{src_dir}application.css", "app/assets/stylesheets/")
FileUtils.cp("#{src_dir}application.rb", "config/")
FileUtils.cp("#{src_dir}zh-CN.yml", "config/locales/")

run "bundle install"

generate(:controller, "home", "index", "--no-helper", "--no-assets", "--skip-routes")
