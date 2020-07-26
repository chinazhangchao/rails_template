# frozen_string_literal: true

require 'fileutils'

route "root 'home#index'"

src_dir = File.expand_path(__dir__) + '/'

gem 'rails-i18n', '~> 6.0.0'
gem 'semantic-ui-sass'
gem 'dotenv-rails'
gem 'list_spider'
gem 'whenever', require: false
gem 'caxlsx'
gem 'caxlsx_rails'
gem 'rubocop', '~> 0.86.0', require: false

FileUtils.cp("#{src_dir}.env", './')
FileUtils.cp("#{src_dir}.env.production", './')
FileUtils.cp("#{src_dir}.gitignore", './')
FileUtils.cp("#{src_dir}.rubocop.yml", './')
FileUtils.cp("#{src_dir}bg_dev.sh", './')
FileUtils.cp("#{src_dir}bg_test.sh", './')
FileUtils.cp("#{src_dir}bg_production.sh", './')
FileUtils.cp("#{src_dir}debug.sh", './')
FileUtils.cp("#{src_dir}test.sh", './')
FileUtils.cp("#{src_dir}production.sh", './')
FileUtils.cp("#{src_dir}preconfig.sh", './')
FileUtils.cp("#{src_dir}restart_bg_dev.sh", './')
FileUtils.cp("#{src_dir}restart_bg_production.sh", './')
FileUtils.cp("#{src_dir}restart_bg_test.sh", './')
FileUtils.cp("#{src_dir}stop_server.sh", './')
FileUtils.cp("#{src_dir}check_code.sh", './')
FileUtils.cp("#{src_dir}compile_assets.sh", './')
# FileUtils.cp_r("#{src_dir}kaminari", "app/views/")
# FileUtils.cp_r("#{src_dir}devise", "app/views/")
remove_file('app/assets/stylesheets/application.css')
FileUtils.cp("#{src_dir}application.css.scss", 'app/assets/stylesheets/')
FileUtils.cp("#{src_dir}application.html.erb", 'app/views/layouts/')
# FileUtils.cp("#{src_dir}devise.rb", "config/initializers/")

inject_into_file 'config/application.rb', before: "  end\nend" do
  <<~EOF
    config.generators.assets = false
    config.generators.helper = false

    config.time_zone = 'Beijing'
    config.i18n.available_locales = %i[en zh-CN]
    config.i18n.default_locale = :'zh-CN'
  EOF
end

FileUtils.cp("#{src_dir}zh-CN.yml", 'config/locales/')
# FileUtils.cp("#{src_dir}rails.zh-CN.yml", "config/locales/")
# FileUtils.cp("#{src_dir}devise.zh-CN.yml", "config/locales/")

after_bundle do
  run 'yarn add jquery popper.js semantic-ui-sass'

  inject_into_file 'config/webpack/environment.js', after: "module.exports = environment\n" do
    <<~EOF
      const webpack = require("webpack")

      environment.plugins.append("Provide", new webpack.ProvidePlugin({
        $: 'jquery',
        jQuery: 'jquery',
        Popper: ['popper.js', 'default']
      }))
    EOF
  end

  inject_into_file 'app/javascript/packs/application.js', after: "require(\"channels\")\n" do
    <<~EOF
      require("semantic-ui-sass")
      
      document.addEventListener("turbolinks:load", function () {
          $('.ui.checkbox').checkbox();
      })
    EOF
  end

  generate(:controller, 'home', 'index', '--skip-routes')
end
