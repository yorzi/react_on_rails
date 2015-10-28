shared_examples ":redux:base" do
  it "copies redux version of package.json" do
    assert_file "client/package.json" do |contents|
      assert_match(/redux/, contents)
    end
  end

  it "creates redux directories" do
    dirs = %w(actions constants middlewares reducers utils)
    dirs.each { |dirname| assert_directory "client/app/#{dirname}" }
  end

  it "copies redux version of clientGlobals" do
    assert_file "client/app/startup/clientGlobals.jsx" do |contents|
      assert_match(/window.ReduxApp = ReduxApp;/, contents)
      assert_match(%r{import ReduxApp from './ClientReduxApp';}, contents)
    end
  end

  it "copies base redux files" do
    assert_file "client/app/reducers/reducersIndex.jsx"
    assert_file "client/app/startup/ClientReduxApp.jsx"
  end
end

shared_examples ":redux:server_rendering" do
  include_examples ":redux:base"

  it "copies redux version of serverGlobals" do
    assert_file "client/app/startup/serverGlobals.jsx" do |contents|
      assert_match(%r{import ReduxApp from './ServerReduxApp';}, contents)
      assert_match(/global.ReduxApp = ReduxApp;/, contents)
    end
  end
end

shared_examples ":redux:hello_world_example" do
  include_examples ":redux:base"

  it "copies redux 'Hello World' example files" do
    %w(client/app/actions/HelloWorldActions.jsx
       client/app/constants/HelloWorldConstants.jsx
       client/app/reducers/HelloWorldReducer.jsx
       client/app/components/HelloWorldContainer.jsx
       client/app/components/HelloWorldRedux.jsx).each { |file| assert_file(file) }
  end

  it "copies the Redux with hello world example version of reducersIndex" do
    assert_file "client/app/reducers/reducersIndex.jsx" do |contents|
      assert_match(%r{import helloWorldReducer from './HelloWorldReducer';}, contents)
    end
  end

  it "copies the Redux with hello world example version of hello_world/index.html.erb" do
    assert_file "app/views/hello_world/index.html.erb" do |contents|
      assert_match(/react_component\("ReduxApp", trace: true\)/, contents)
      refute_match(/react_component\("HelloWorld", trace: true\)/, contents)
    end
  end
end

shared_examples ":redux:server_rendering:hello_world_example" do
  include_examples ":redux:base"
  include_examples ":redux:hello_world_example"

  it "copies redux server rendering files" do
    assert_file "client/app/startup/ServerReduxApp.jsx"
  end

  it "copies the Redux with hello world example with server rendering version of hello_world/index.html.erb" do
    assert_file "app/views/hello_world/index.html.erb" do |contents|
      assert_match(/react_component\("ReduxApp", {}, prerender: true, trace: true\)/, contents)
    end
  end

  it "copies the redux with hello_world_example version of serverGlobals" do
    assert_file("client/app/startup/serverGlobals.jsx") do |contents|
      assert_match(%r{import ReduxApp from './ServerReduxApp';}, contents)
      assert_match(/global.ReduxApp = ReduxApp;/, contents)
      refute_match(/global.HelloWorldApp = HelloWorldApp;/, contents)
      refute_match(/global.MyReactComponent = MyReactComponent;/, contents)
      refute_match(%r{import HelloWorld from '../components/HelloWorld';}, contents)
      refute_match(%r{import MyReactComponent from '../components/MyReactComponent';}, contents)
    end
  end
end
