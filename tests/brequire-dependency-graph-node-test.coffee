DependencyGraphNode = require('../plugins/brequire/dependency-graph-node')
path = require('path')
assert = require('assert')

# ## setup

fullPath = require.resolve('../plugins/brequire/dependency-graph-node')
node = new DependencyGraphNode(fullPath)

# ## body (and compilation, since it's a coffeescript file)

assert node.body, 'has a body'

# ## requires

requires = node.requires
assert requires.length is 3, 'has 3 dependencies'
assert requires[0] is 'fs', 'requires fs'
assert requires[1] is 'path', 'requires path'
assert requires[2] is 'detective', 'requires detective'

# ## toJSON

node2 = new DependencyGraphNode(fullPath)

node.name = 'node'
node.children = [node2]
node2.name = 'node2'
node2.children = []

assert.equal JSON.stringify(node),
  '{"name":"node","children":[{"name":"node2","children":[]}]}'
