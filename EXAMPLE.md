```ruby
#!/usr/bin/env ruby

require_relative '../config/boot'
require 'handy_toolbox'
include HandyToolbox

# dummy rake loader
class RakeLoader < Loader
  def on_load(node)
    `rake -T`.strip.split("\n").each do |rake|
      name, desc = rake.split("#")
      node.tool name.strip, desc: desc.strip
    end
  end
end

# db tasks
class RailsDatabasePlugin < Plugin
  def on_attach(node)
    node.menu 'Database' do |db|
      db.tool 'rails db:migrate', name: 'Migrate database'
      db.tool 'rails db:test:prepare', name: 'Prepare test database'
    end
  end
end

branch = Cmd.exec('git branch').match(/^\* (?<name>.+)$/)[:name]
app = App.new(title: "My Project (on #{branch})")
app.menu_loader 'Rake', RakeLoader
app.menu 'Rails' do |rails|
  rails.plugin RailsDatabasePlugin
  rails.menu_loader 'Rake', RakeLoader
end
app.menu 'Deployment' do |deploy|
  deploy.tool 'cap staging deploy', name: 'Deploy to staging'
  deploy.menu 'Deploy to production' do |production|
    production.tool 'cap production deploy', name: 'I understand consequences, do it!'
  end
end
app.run
```
