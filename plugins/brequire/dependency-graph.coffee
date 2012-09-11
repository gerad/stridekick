path = require('path')
Module = require('module')
DependencyGraphNode = require('./dependency-graph-node')

class DependencyGraph
  constructor: (rootPath, parentPath) ->
    @_cache = {}
    @rootDir = path.dirname(@resolve(rootPath, parentPath))

    @root = @add(rootPath, parentPath)

  # `add` adds a dependency to the graph, then it recursively adds all of that
  # dependency's requirements
  add: (modulePath, parentPath) ->
    fullPath = @resolve(modulePath, parentPath)
    @_cache[fullPath] ?= do =>
      node = new DependencyGraphNode(fullPath)

      # give the node a unique filename
      node.name = @inferName(fullPath)

      # recursively add all of the children for the node
      children = {}
      for childPath in node.requires
        children[childPath] = @add(childPath, fullPath)

      node.children = children

      node

  # `resolve` uses the node module system's built-in module name resolution
  # mechanism to determine the full path to a file from the parent's path and
  # the given module path
  resolve: (modulePath, parentPath) ->
    try
      Module._resolveFilename(modulePath,
        id: parentPath
        filename: parentPath
        paths: Module._nodeModulePaths(parentPath))
    catch e
      if /^Cannot find module/.test(e.message)
        e.message += " required by #{parentPath}"
      throw e

  # `nodes` returns an array of nodes for the graph. The nodes are returned
  # in dependency order. That is, when possible, nodes that are dependencies
  # of other nodes are returned before the nodes that depend on them.
  nodes: (node, list=[]) ->
    if not node?
      # start by adding the root node
      @nodes(@root, list)
    else
      # if the node is already in the list, remove it
      for item, i in list
        break if item is node
      list.splice(i, 1)

      # add this node to the front
      list.unshift(node)

      # add this node's children to the list
      for childPath, child of node.children
        @nodes(child, list)

    list

  # `inferName` tries to determine a unique name for the node.
  inferName: (fullPath) ->
    # find the path relative to the root path
    relativePath = path.relative(@rootDir, fullPath)

    # remove any slashes or dots from the begining of the path
    name = relativePath.replace(/^[.\/]+/, '')

    # remove the extension
    name = name.replace(/\.[^\.]+$/, '')

    # if it's an index file, remove it
    name = name.replace(/\/index$/, '')

    name

  toJSON: -> @root.toJSON()

module.exports = DependencyGraph
