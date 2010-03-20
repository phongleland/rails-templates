load_template "/Users/phongleland/Projects/rails_templates/base.rb"

name = ask("What do you want a user to be called?")
generate :nifty_authentication, name
rake "db:migrate"

git :add => "."
git :commit => "-m 'adding authentication'"

generate :controller, "welcome index"
route "map.root :controller => 'welcome'"
git :rm => "public/index.html"

git :add => "."
git :commit => "-m 'adding welcome controller'"
