# HandyToolbox

HandyToolbox is a text based user interface that will help you with every day tasks, so:

1. Define your tasks and organize them into groups.
2. And from now on you can forget all rake, capistrano, heroku, npm, ... commands.

Gem was built for the Rails apps in mind but can be used standalone as well and not only for Ruby related stuff.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'handy_toolbox'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install handy_toolbox

## Setup

### Rails On Rails project integration

Create `tools` file in your `project/bin/` folder and paste this code:

```ruby
#!/usr/bin/env ruby

require_relative '../config/boot'
require 'handy_toolbox'
include HandyToolbox

app = App.new(title: 'Project name')
# your config
app.run
```

### Defining your tasks

Other example [here](EXAMPLE.md).

```ruby
...
app.menu 'Quick' do |quick|
  quick.tool 'rubocop -c config/rubocop.yml', name: 'RuboCop'
  quick.tool 'heroku pg:pull HEROKU_POSTGRESQL_SOMETHING mylocaldb --app my_app', name: 'Download production database'
  quick.tool 'pkill -f puma', name: 'Kill all puma workers'
end

app.menu 'Tests' do |tests|
  tests.tool 'npm test', name: 'Run frontend tests'
  tests.tool 'rspec spec/', name: 'Run RSpec tests'
  tests.tool 'imagine very complicated command here', name: 'Run those tests you always forget how to run'
end

app.menu 'Rails' do |rails|
  rails.menu 'Database' do |db|
    db.tool 'rails db:migrate'
    db.tool 'rails db:test:prepare', name: 'Prepare test database'    
  end
  rails.menu 'Assets' do |assets|
    assets.tool 'rake assets:precompile', desc: 'Precompile all the assets'
  end
end

app.menu 'Deployment' do |deploy|
  # for heroku
  deploy.tool 'git push staging master', name: 'Deploy to staging'
  deploy.tool 'git push heroku master', name: 'Deploy to production'

  # for capistrano
  deploy.tool 'cap staging deploy', name: 'Deploy to staging'
  deploy.tool 'cap production deploy', name: 'Deploy to production'
end

...
```

#### Configuration details

##### Menu

Menus can be nested, they aggregate other menus or tasks. On every menu node you can define: other menus, tools, plugins and loaders.

```ruby
app.menu 'Menu' do |node|
  node.menu 'Sub menu' do |sub|
    ...
  end
end
```

##### Tool

Tools are your commands that will be passed to your shell and executed.

```ruby
app.tool 'ls -la'
# you will see this task as 'ls -la', and 'ls -la' will be executed

app.tool 'ls -la', name: 'Show files'
# you will see 'Show files', and 'ls -la' will be executed

app.tool 'ls -la', name: 'Show files', desc: 'Lists all the files and their details'
# you will see this:
#    # Lists all the files and their details
#    Show files
# and will execute 'ls -la'
```

##### Plugin

Plugins allow you to build your task tree more modularly (rather than keeping everything in one file).

```ruby
# For every plugin you need to implement '#on_attach' method and you can build your tree from there.
class RailsDatabasePlugin < Plugin # HandyToolbox::Plugin
  def on_attach(node)
    node.menu 'Database' do |db|
      db.tool 'rails db:migrate', name: 'Migrate database'
      db.tool 'rails db:test:prepare', name: 'Prepare test database'
    end
  end
end

# Install a plugin (#on_attach is called immediately)
app.plugin RailsDatabasePlugin
```

##### Loader

Loaders allow you to build your task tree in a lazy fashion. When toolbox starts only menu node is created.
Once you enter the menu, loader will populate your tree.

Be aware that loader will freeze UI for a moment (until loading is finished).

Personally I encourage you to define your tasks explicitly (you know what you have and you can keep only important stuff) rather than loading them via long running procedures.

```ruby
# For every loader you need to implement '#on_load' method and you can build your tree from there.
# Method is run only once per toolbox lifecycle.
# Here: Dummy rake tasks loader, 'rake -T' takes some time
class RakeLoader < Loader
  def on_load(node)
    `rake -T`.strip.split("\n").each do |rake|
      name, desc = rake.split("#")
      node.tool name.strip, desc: desc.strip
    end
  end
end

app.menu_loader 'Rake tasks', RakeLoader
# This will create menu 'Rake tasks' and once you decide to enter this menu it will call #on_load.
```

### Usage

In terminal in your project's folder execute:

```
./bin/tools # you can also create some alias to it, it all depends how lazy you are
```

Shortcuts:
```
q - quits the toolbox
arrow up / arrow down - navigate through menus and tasks
enter - open menu or execute task
page up / page down - navigate faster (skips 10 items)
home / end - go to first/last item
```

![Main menu](promo/1.png?raw=true)

![Quick tasks](promo/2.png?raw=true)

![Nested menu with loader not executed yet](promo/3.png?raw=true)

![Loaded data from loader](promo/4.png?raw=true)

## TODO

- Test it on OSX
- Allow tasks to be loaded from YML file (and from user's HOME dir i.e. ~/.handy.yml)


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/qbart/handy_toolbox.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
