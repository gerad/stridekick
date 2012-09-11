# # brequire
#
# Use `require` in browser-side code. Like `browserify` but lighter-weight.
#
# * uses existing node `require` path resolution and compilation code
# * no code rewriting in development
# * minimal code wrapping in development (line #s don't change)
# * keeps files in separate resources in development
# * plays nicely with non-node modules (like jquery and backbone)
# * works great with express/connect
#
# The motivation for this package was wanting to share javascript code both
# client and server-side. Especially wanting to write lots of server side
# tests for client side code, without using a complicated test library.
#
# Browserify is great, but it was doing more than I wanted it to, and was more
# complicated than I needed for this use case. Since substack had released
# [detective] as stand-alone module, and the node require system is already so
# flexible, it was fairly easy to roll my own solution. Hence, `brequire`.
#
# ## Usage with Express
#
# Write javascript as you normally would write it using `require`.
#
# ```javascript
# // public/javascripts/index.js
# require('../vendor/jquery');
# var mymodule = require('./mymodule');
# var npmmodule = require('npmmodule');
# mymodule.dosomething({ with: npmmoudle })
#```
#
# Then, in your express configuration, `brequire` that file.
#
# ```javascript
# express.use(brequire("./public/javascripts/index.js"))
# ```
#
# Pass req.brequire through to your templates in your routes.
#
# ```javascript
# app.get('/', function(req, res, next) {
#   res.render('index', { javascripts: req.brequire });
# });
# ```
# Finally, in your layout, render the brequire where you would normally
# render javascripts.
#
# ```ejs
# <html>
#   <body>
#     ...
#     <%= javascripts() %>
#   </body>
# </html>
# ```
#
# In development, this will result in output like this:
#
# ```html
# <html>
#   <body>
#     ...
#     <script src="/javascripts/brequire.js"></script>
#     <script src="/javascripts/jquery.js"></script>
#     <script src="/javascripts/mymodule.js"></script>
#     <script src="/javascripts/npmmodule.js"></script>
#     <script src="/javascripts/index.js"></script>
#     <script>brequire('index');</script>
#   </body>
# </html>
# ```
#
# In production, all the files will be minified, and concatenated into a
# single script file and served off a custom route with browser headers set to
# never expire.

DependencyGraph = require('./dependency-graph')
url = require('url')

brequire = (filePath, parentPath) ->
  # assume the first path is relative to cwd (if it's not passed in)
  parentPath ?= process.cwd()

  brequire = new Brequire(filePath, parentPath)
  scripts = brequire.scripts()

  (req, res, next) ->
    if (script = brequire.scriptForRequest(req))?
      res.writeHead(200, 'Content-Type': 'application/javascript')
      res.end(script)
      if /jquery/.test req.url
        console.log(script)
    else
      req.brequire = -> scripts
      next()

class Brequire
  constructor: (filePath, parentPath) ->
    @graph = new DependencyGraph(filePath, parentPath)
    @nodes = @graph.nodes()

    @nodesByPath = {}
    for node in @nodes
      node.path = "/javascripts/#{node.name}.js"
      @nodesByPath[node.path] = node

  scriptForRequest: (req) ->
    pathname = url.parse(req.url).pathname
    if pathname is '/javascripts/brequire.js'
      @brequireScript()
    else if (node = @nodesByPath[pathname])?
      @scriptForNode(node)

  scripts: ->
    scripts = for node in @nodes
      "<script src=\"#{node.path}\"></script>"

    """
    <script src="/javascripts/brequire.js"></script>
    #{scripts.join("\n")}
    <script>brequire('#{@graph.root.name}')</script>
    """

  scriptForNode: (node) ->
    """
    brequire.fns['#{node.name}'] = function(require, module, exports) {
      #{node.body}
    };
    """

  brequireScript: ->
    """
    function brequire(name) {
      if (!brequire._cache[name]) {
        var module = {};
        var exports = module.exports = {};
        brequire._cache[name] = module;

        function require(path) {
          return brequire._resolve(path, name);
        }

        brequire.fns[name].call(window, require, module, exports);
      }

      return brequire._cache[name].exports;
    }
    brequire.fns = {};
    brequire._cache = {};
    brequire._resolve = function(path, parent) {
      var nameLookup = #{JSON.stringify(@nameLookup())};
      return brequire(nameLookup[parent][path]);
    }
    """

  nameLookup: ->
    nameLookup = {}
    for node in @nodes
      lookup = nameLookup[node.name] = {}
      for path, child of node.children
        lookup[path] = child.name
    nameLookup

module.exports = brequire
