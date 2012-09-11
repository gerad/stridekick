# Stridekick
## Get out and play together

### Installing

1. `brew install node` # install node and npm
2. `npm install` # install depencies
3. `npm start` # start the development server
4. `open http://localhost:4000` # visit the page

### Deploying

TODO

### Developing

* indentation is 2 spaces
* try to keep lines at <80 chars
* lean aggressive on documentation; docco format

### Directory Structure

Here's how files are organized:

* `client.coffee` - the main entry point for javascript on the client
* `server.coffee` - the main entry point for javascript on the server
* `assets/` - contains source code for assets that should be made available on
  the client. Some of these assets are compiled behind the scenes and actually
  served out of `tmp/cache`.
  * `images`
  * `javascripts` - javascripts for the client, `brequire` does dependency
    resolution so that `require`d javascript files are correctly made
    available on the client.
  * `stylesheets` - stylesheets for the client, stylus files will get compiled
    into (and served out of) `tmp/cache`. `nib` is available to stylus files.
* `config` - configuration files for the server
  * `express.coffee` - sets up the server
  * `routes.coffee` - handles setting up the routing, if you want a new route
    to work, add it here, and add the route handling code to the `controllers`
    directory.
  * `stylus.coffee` - handles setting up stylus.
* `controllers` - code in this directory handles processing of routes.
  `controller.coffee` has the code for a Rails style restful controller, which
  can be subclassed for other controllers.
* `helpers` - are reminiscent of the Rails pattern of the same name.
  Essentially, it's often nice to keep code complexity out of a template, just
  passing it a simple json object to render. This makes writing tests and
  maintaining templates simpler. The code that would go into the template can
  go into the helper instead.
* `models` - these are the domain objects for the application. They should be
  unaware of the view, easy to test, and very reusable.
* `plugins` - these are just things that probably should be their own node
  modules, but are internally developed and relatively specific to this
  project.
* `routers` - these are client-side routers for controlling the backbone app.
* `templates` - jade templates that can be rendered on the server or on the
  client.
* `tests` - the tests for the app, at the moment, there is no test framework
  used, instead the built-in `assert` library handles running the tests.
  * `fixtures` - setup files that tests may need
* `tmp` - temporary files that can be deleted and recreated, this is ignored
  by git but will get generated automatically.
* `utilities` - where javascript that didn't fit anywhere else goes, includes
  things like jquery plugins and general purpose helper methods
* `views` - these are backbone views, they should probably be called "view
  controllers" as they are responsible for syncing state between the model on
  the backend and what's happening in the browser DOM on the client.
