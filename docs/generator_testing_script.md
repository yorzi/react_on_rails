Per running steps:
​
From directory of `react_on_rails`, with a test app named "react_on_rails_gen"

```bash
cd ..
rails new react_on_rails_gen
cd react_on_rails_gen
git init
git add .
git commit -m "Rails new plus react_on_rails"
```
​
Edit the Gemfile, adding these 2 lines:

```ruby
gem 'react_on_rails', path: '../react_on_rails'
gem 'therubyracer'
```

Note the relative path to the react_on_rails gem.
​
```bash
bundle
git commit -am "added react_on_rails gem"
```
​
You can now mess around with the generator:

```bash
# See available options
rails generate react_on_rails:install --help
# Actual install, for example, with Redux
rails generate react_on_rails:install --redux
```

If you do actually run the generator, then you can see the changes that the generator made, ready for a commit.
​
Then run:
​
```bash
cd client
npm install
npm run build:client
# OR if you are testing server rendering
npm run build:server
cd ..
rails s
# if `rails s` isn't working, try `foreman start -f Procfile.dev`
```
​
Then visit port `3000`. If you didn't use the `--skip_hello_world_example` option when generating, then you can visit `localhost:3000/hello_world` to see it.
​
That's it!
