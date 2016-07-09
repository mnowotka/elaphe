define ['exports', 'core/exceptions', 'lodash'], (exports, Exceptions, _) ->
  findKey: (obj, value) ->
    key = null
    _.each obj, (v, k) ->
      if (v is value)
        key = k
    return key

  class AdjacencyList
    constructor: ->
      @edges = []
      @vertices = []
      @adjacencyList = []

    copy: ->
      ret = new AdjacencyList()
      ret.edges = _.copy @edges
      ret.vertices = _.copy @vertices
      ret.adjacencyList = _.copy @adjacencyList
      return ret

    getNumVertices: -> @vertices.length

    getVertices: -> @vertices

    getNumEdges: -> @edges.length

    getEdges: -> @edges

    getVertexEdgesIdx: (what) ->
      if _.isInteger what
        return @adjacencyList[what]
      return @adjacencyList[what.index]

    getVertexEdges: (what) ->
      ids = @getVertexEdgesIdx(what)
      if ids
        @edges[idx] for idx in ids

    getEdgeBetweenVertices: (idx1, idx2) ->
      vEdges = @getVertexEdgesIdx(idx1)
      if vEdges
        edgeIdx = vEdges[idx2]
        if edgeIdx
          @edges[edgeIdx]

    getDegree: (what) ->
      @getVertexEdgesIdx(what).length

    getAdjacentVerticesIdx: (what) ->
      _.keys(@getVertexEdgesIdx what)

    getAdjacentVertices: (what) ->
      ids = @getAdjacentVerticesIdx(what)
      if ids
        @vertices[idx] for idx in ids

    addVertex: (vertex) ->
      @vertices.push(vertex)
      idx = @vertices.length - 1
      @adjacencyList.push({})
      return idx

    addEdge: (beginVertex, endVertex, edge) ->
      @edges.push(edge)
      idx = @edges.length -1
      @adjacencyList[beginVertex][endVertex] = idx
      @adjacencyList[endVertex][beginVertex] = idx
      return idx

    removeVertex: (what) ->
      if _.isInteger what
        idx = what
      else
        idx = what.index
      edges = _.values(@adjacencyList[idx])
      @vertices.splice(idx, 1)
      for i in [0..@adjacencyList.length]
        ed = @adjacencyList[i]
        @adjacencyList[i] = _.fromPairs((if v_idx < idx then [v_idx, e_id] else [v_idx -1,
          e_id]) for v_idx, e_id of ed when v_idx isnt idx)
      @removeEdges(edges)

    removeEdges: (edgesIdxs) ->
      @edges = edge for edge in @edges when edge not in edgesIdxs
      for i in [0..@adjacencyList.length]
        ed = @adjacencyList[i]
        @adjacencyList[i] = _.fromPairs([v_idx,
          e_id - _.sum(1 for e in edgesIdxs when e < e_id)] for v_idx, e_id of ed when e_id not in edgesIdxs)

    removeEdge: (what) ->
      if _.isInteger what
        idx = what
      else
        idx = what.index
      @edges.splice(idx, 1)
      for i in [0..@adjacencyList.length]
        ed = @adjacencyList[i]
        @adjacencyList[i] = _.fromPairs((if e_id < idx then [v_idx, e_id] else [v_idx,
          e_id - 1]) for v_idx, e_id of ed when e_id isnt idx)

    removeEdgeBetweenVertices: (idx1, idx2) ->
      edge_idx = @adjacencyList[idx1][idx2]
      @adjacencyList[idx1] = _.omit(@adjacencyList[idx1], idx2)
      @adjacencyList[idx2] = _.omit(@adjacencyList[idx1], idx1)
      @edges.splice(edge_idx, 1)
      for i in [0..@adjacencyList.length]
        ed = @adjacencyList[i]
        for v_idx, e_id of ed
          if e_id > edge_idx
            @adjacencyList[i][v_idx] -= 1

  exports.AdjacencyList = AdjacencyList
