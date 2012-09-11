DependencyGraph = require('../plugins/brequire/dependency-graph')
assert = require('assert')

# ## setup

graph = new DependencyGraph('./fixtures/brequire/a', __filename)

# ## root

assert graph.root.name is 'a', 'root name is correct'

children = for path, child of graph.root.children
  child

assert children.length is 1, 'root has 1 child'
assert children[0].name is 'b', 'child has correct name'

# ## toJSON (integration test, really)

assert JSON.stringify(graph) is
  '{"name":"a","children":{"./b":{"name":"b","children":{}}}}',
  "JSON is correct"

# ## nodes

nodes = graph.nodes()
assert nodes.length is 2, 'has 2 nodes'
assert nodes[0].name is 'b', 'first node is correct'
assert nodes[1].name is 'a', 'second node is correct'

# ## infer name

graph2 = new DependencyGraph('./fixtures/brequire/c', __filename)
assert graph2.root.children['./d/d'].name is 'd/d', 'd has correct name'
