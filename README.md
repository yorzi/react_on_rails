[![Build Status](https://travis-ci.org/shakacode/react_on_rails.svg?branch=master)](https://travis-ci.org/shakacode/react_on_rails) [![Coverage Status](https://coveralls.io/repos/shakacode/react_on_rails/badge.svg?branch=master&service=github)](https://coveralls.io/github/shakacode/react_on_rails?branch=master) [![Dependency Status](https://gemnasium.com/shakacode/react_on_rails.svg)](https://gemnasium.com/shakacode/react_on_rails) [![Gem Version](https://badge.fury.io/rb/react_on_rails.svg)](https://badge.fury.io/rb/react_on_rails)

# React on Rails

React on Rails integrates Facebook's [React](https://github.com/facebook/react) front-end framework with Rails. Currently, both React v0.14 and v0.13 are supported. See the Rails on Maui [blog post](http://www.railsonmaui.com/blog/2014/10/03/integrating-webpack-and-the-es6-transpiler-into-an-existing-rails-project/) that started it all!

Unlike the [react-rails](https://github.com/reactjs/react-rails) gem, which depends heavily on sprockets and jquery-ujs, React on Rails uses [webpack](http://webpack.github.io/) and does not depend on jQuery. While the initial setup is slightly more involved, it allows for advanced functionality such as:

+ Server-side rendering with fragment caching
+ [Turbolinks](https://github.com/rails/turbolinks)
+ [Redux](https://github.com/rackt/redux)
+ [Webpack dev server](https://webpack.github.io/docs/webpack-dev-server.html) with [hot module replacement](https://webpack.github.io/docs/hot-module-replacement-with-webpack.html)
+ [Webpack optimization functionality](https://github.com/webpack/docs/wiki/optimization)
+ **(Coming Soon)** [React Router](https://github.com/rackt/react-router)

See the [react-webpack-rails-tutorial](https://github.com/justin808/react-webpack-rails-tutorial/) for an example of a live implementation and code.

## Getting Started
1. Add the following to your Gemfile and bundle install:
  
  ```ruby
  gem "react_on_rails"
  gem "therubyracer"
  ```

2. Run the generator with a simple "Hello World" example:

  ```bash
  rails generate react_on_rails:install --hello_world_example
  ```

3. NPM install and build client bundle:

  ```bash
  cd client 
  npm install
  npm run build:client
  ```

4. Start your Rails server:

  ```bash
  foreman start -f Procfile.dev
  ```

## How it Works
The generator installs your webpack files in the `client` folder. You then use webpack to compile your code and output the bundled results to `app/assets/javascripts/generated`, which are then loaded by sprockets. These generated bundle files have been added to your `.gitignore` for your convenience.

In most cases, you should then use the provided helper method to render the React component from your Rails views. In some cases, such as when SEO is vital or many users will not have JavaScript enabled, you can pass the `--server-rendering` option to the generator to configure your application for server-side rendering. Your JavaScript can then be first rendered on the server and passed to the client as HTML.

### Building the Bundles
Each time you change your client code, you will need to re-generate the bundles:

+ *Normal Mode (JavaScript is rendered on client):*

  ```bash
  cd client
  npm run build:client
  ```
+ *Server-Side Rendering:*

  ```bash
  npm run build:server
  ```

### Globally Exposing Your React Components
Place your JavaScript code inside of the provided `client/app` folder. Use modules just as you would when using webpack alone. The difference here is that instead of mounting React components directly to an element using `React.render`, you **expose your components globally and then mount them with helpers inside of your Rails views**.

+ *Normal Mode (JavaScript is Rendered on client):*

  ```javascript
  window.MyReactComponentApp = MyReactComponentApp;
  ```
+ *Server-Side Rendering:*

  ```javascript
  global.MyReactComponentApp = MyReactComponentApp;
  ```
   
### Including Your JavaScript in Rails Views
Once the bundled files have been generated in your `app/assets/javascripts/generated` folder and you have exposed your components globally, you will want to run your code in your Rails views using the included helper method (for more on the helper methods, [see below](#helpers)).

+ *Normal Mode (JavaScript is rendered on client):*

  ```erb
  <%= react_component("MyReactComponentApp") %>
  ```
+ *Server-Side Rendering:*

  ```erb
  <%= react_component("MyReactComponentApp", {}, prerender: true) %>
  ```

The `component_name` parameter here would be a string matching the name you used when globally exposing your React component.

### Using Images and Fonts
The generator has created two symbolic links in your `client/app` folder that point to the fonts and images folders in Rails (meaning the ones inside of `app/assets/`). All of your fonts and images should still be kept in those folders. They will be visible for you to reference from your client application if you choose to do so.

## Helpers In-Depth
`react_component(component_name, props = {}, options = {})`
+ **react_component_name:** Can be a React component, created using a ES6 class, or `React.createClass`, or a generator function that returns a React component.
+ **props:** Ruby Hash which contains the properties to pass to the react object
+ **options:**
  + **generator_function:** default is false, set to true if you want to use a generator function rather than a React Component.
  + **prerender:** enable server-side rendering of component. Set to false when debugging!
  + **trace:** set to true to print additional debugging information in the browser. Defaults to true for development, off otherwise.
  + **replay_console:** Default is true. False will disable echoing server-rendering logs to the browser. While this can make troubleshooting server rendering difficult, so long as you have the default configuration of logging_on_server set to true, you'll still see the errors on the server.
+ Any other options are passed to the content tag, including the id

`def server_render_js(js_expression, options = {})`

This is a helper method that takes any JavaScript expression and returns the output from evaluating it. If you have more than one line that needs to be executed, wrap it in an IIFE. JS exceptions will be caught and console messages handled properly.

## Developing with Webpack Dev Server
While developing your client code, you *could* simply re-build anytime you make a change, boot up your Rails server, and view the result. However, you would be missing out on the benefits of [webpack's dev server](https://webpack.github.io/docs/webpack-dev-server.html) and its [hot module replacement](https://webpack.github.io/docs/hot-module-replacement-with-webpack.html) functionality.

Instead of going through Rails, you can use the generated `client/server.js` to start up the dev server and load the provided `client/index.jade`. (You will need to configure this file to load your client app inside of a `script` tag.) Then, all you need to do is run the build script and start the server:

+ *Normal Mode (JavaScript is Rendered on client):*

  ```bash
  cd client
  npm run build:dev:client
  npm start
  ```
+ *Server-Side Rendering:*

  ```bash
  cd client
  npm run build:dev:server
  npm start
  ```

Open your browser to `localhost:4000`. Whenever you make changes to your JavaScript code in the `client` folder, they will automatically show up in the browser. Hot module replacement is already enabled by default.

### Adding Additional Routes for the Dev Server
As you add more routes to your front-end application, you will need to make the corresponding API for the dev server in `client/server.js`. See our example `server.js` from our [tutorial](https://github.com/shakacode/react-webpack-rails-tutorial/blob/master/client/server.js).

## Node Dependencies and NPM
### Updating

```bash
cd client
npm install -g npm-check-updates
rm npm-shrinkwrap.json
npm-check-updates -u
npm install
npm prune
npm shrinkwrap
```

Confirm that the hot replacement dev server and the Rails server both work. You may have to delete `node_modules` and `npm-shrinkwrap.json` and then run `npm shrinkwrap`.

*Note: `npm prune` is required before running `npm shrinkwrap` to remove dependencies that are no longer needed after doing updates.*

### Adding New Dependencies
Typically, you can add your Node dependencies as you normally would. Occasionally, adding a new dependency may require removing and re-running `npm shrinkwrap`:

```bash
cd client
npm install --save module_name@version
# or
# npm install --save_dev module_name@version
rm npm-shrinkwrap.json
npm shrinkwrap
```

## Generator Options
Run `rails generate react_on_rails:install --help` for descriptions of all available options.

## Linters
The React on Rails generator automatically adds linters and their recommended accompanying configurations to your project (to disable this behavior, include the `--no-linters` option when running the generator). Those linters that are written in Ruby have been added to your Gemfile, and those that run in Node have been add to your `package.json` under `devDependencies`.

To run the linters (runs both Ruby and Node linters):

```bash
rake lint
```

## Manual Installation and Configuration
See [Manual Configuration](docs/manual_configuration.md).

## Contributing
Bug reports and pull requests are welcome. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to our version of the [Contributor Covenant](contributor-covenant.org) code of conduct (see [CODE OF CONDUCT](CODE_OF_CONDUCT.md)).

See [Contributing](docs/Contributing.md) to get started.

## License
The gem is available as open source under the terms of the [MIT License](LICENSE).

## Authors
[The Shaka Code team!](http://www.shakacode.com/about/)

1. [Justin Gordon](https://github.com/justin808/)
2. [Samnang Chhun](https://github.com/samnang)
3. [Alex Fedoseev](https://github.com/alexfedoseev)

And based on the work of the [react-rails gem](https://github.com/reactjs/react-rails)

## About [ShakaCode](http://www.shakacode.com/)

Visit [our forums!](http://forum.shakacode.com)

If you're looking for consulting on a project using React and Rails, email us ([contact@shakacode.com](mailto: contact@shakacode.com))! You can also join our slack room for some free advice.

We're looking for great developers that want to work with Rails + React with a distributed, worldwide team, for our own products, client work, and open source. [More info here](http://www.shakacode.com/about/index.html#work-with-us).
