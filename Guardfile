# A sample Guardfile
# More info at https://github.com/guard/guard#readme

## Uncomment and set this to only include directories you want to watch
# directories %w(app lib config test spec features) \
#  .select{|d| Dir.exists?(d) ? d : UI.warning("Directory #{d} does not exist")}

## Note: if you are using the `directories` clause above and you are not
## watching the project directory ('.'), then you will want to move
## the Guardfile to a watched dir and symlink it back, e.g.
#
#  $ mkdir config
#  $ mv Guardfile config/
#  $ ln -s config/Guardfile .
#
# and, you'll have to watch "config/Guardfile" instead of "Guardfile"

guard 'livereload' do
  extensions = {
    css: :css,
    scss: :css,
    sass: :css,
    js: :js,
    coffee: :js,
    html: :html,
    png: :png,
    gif: :gif,
    jpg: :jpg,
    jpeg: :jpeg,
    # less: :less, # uncomment if you want LESS stylesheets done in browser
  }

  rails_view_exts = %w(erb haml slim)

  # file types LiveReload may optimize refresh for
  compiled_exts = extensions.values.uniq
  watch(%r{public/.+\.(#{compiled_exts * '|'})})

  extensions.each do |ext, type|
    watch(%r{
          (?:app|vendor)
          (?:/assets/\w+/(?<path>[^.]+) # path+base without extension
           (?<ext>\.#{ext})) # matching extension (must be first encountered)
          (?:\.\w+|$) # other extensions
          }x) do |m|
      path = m[1]
      "/assets/#{path}.#{type}"
    end
  end

  # file needing a full reload of the page anyway
  watch(%r{app/views/.+\.(#{rails_view_exts * '|'})$})
  watch(%r{app/helpers/.+\.rb})
  watch(%r{config/locales/.+\.yml})
end

guard :minitest, spring: "bin/rails test", all_on_start: false do
  # with Minitest::Unit
  watch(%r{^test/(.*)/?(.*)_test\.rb$})
  # watch('test/test_helper.rb') { 'test' }
  # watch('config/routes.rb')    { integration_tests }
  # watch(%r{^app/models/(.*?)\.rb$}) do |matches|
  #   "test/models/#{matches[1]}_test.rb"
  # end
  # watch(%r{^app/controllers/(.*?)_controller\.rb$}) do |matches|
  #   resource_tests(matches[1])
  # end
  # watch(%r{^app/views/([^/]*?)/.*\.html\.erb$}) do |matches|
  #   ["test/controllers/#{matches[1]}_controller_test.rb"] +
  #   integration_tests(matches[1])
  # end
  # watch(%r{^app/helpers/(.*?)_helper\.rb$}) do |matches|
  #   integration_tests(matches[1])
  # end

  # # Returns the integration tests corresponding to the given resource.
  # def integration_tests(resource = :all)
  #   if resource == :all
  #     Dir["test/integration/*"]
  #   else
  #     Dir["test/integration/#{resource}_*.rb"]
  #   end
  # end

  # # Returns the controller tests corresponding to the given resource.
  # def controller_test(resource)
  #   "test/controllers/#{resource}_controller_test.rb"
  # end

  # # Returns all tests for the given resource.
  # def resource_tests(resource)
  #   integration_tests(resource) << controller_test(resource)
  # end
end
