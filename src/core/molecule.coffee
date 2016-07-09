define ['exports', 'core/element', 'core/periodic_table', 'core/isotope', 'core/constants', 'core/stereo', 'core/hybridization_type',
  'core/bond_type', 'core/bond_direction', 'core_bond_stereo', 'core/bond',
  'core/atom', 'graph/adjacency_list', 'core/ring_info', 'core/exceptions',
  'lodash'], (exports, Elements, PeriodicTable, Isotopes, Constants, Stereo, Hybridization, BondType, BondDirection, BondStereo, Bond, Atom, Graph, RingInfo, Exceptions, _) ->

  class Molecule
    constructor: () ->
      @graph = new Graph()
      @atomBookmarks = {}
      @bondBookmarks = {}
      @ringInfo = new RingInfo()
      @conformers = []
      @properties = {}

    copy: ->
      ret = new Molecule()
      ret.graph = @graph.copy()
      ret.atomBookmarks = _.copy @atomBookmarks
      ret.bondBookmarks = _.copy @bondBookmarks
      ret.ringInfo = @ringInfo.copy()
      ret.conformers = _.copy @conformers
      ret.properties = _.copy @properties

    getNumAtoms: (onlyExplicit = true) ->
      ret = @graph.getNumVertices()
      if not onlyExplicit
          ret += _.sum atom.getTotalNumHs() for atom in @graph.getVertices()
      return ret

    getNumHeavyAtoms: -> (atom for atom in @graph.getVertices() if atom.getAtomicNumber() > 1).length

    getAtomWithIdx: (idx) -> @graph.getVertices()[idx]

    getAtomDegree: (atom) -> @graph.getDegree atom

    getNumBonds: (onlyHeavy = 1) ->
      ret = @graph.getNumEdges()
      if not onlyHeavy
        ret += _.sum atom.getTotalNumHs() for atom in @graph.getVertices()
      return ret

    getBondWithIdx: (idx) -> @graph.getEdges()[idx]

    getBondBetweenAtoms: (idx1, idx2) -> @graph.getEdgeBetweenVertices(idx1, idx2)

    getAtomNeighbors: (atom) -> @graph.getAdjacentVertices(atom)

    getAtomNeighborsIdx: (atom) -> @graph.getAdjacentVerticesIdx(atom)

    getAtomBonds: (atom) -> @graph.getVertexEdges(atom)

    getConformer: (id = -1) ->
      if not @conformers
        return
      if id < 0
        return _.front @conformers
      res = (conformer in @conformers if conformer.id == id)
      if not res
        return
      return res[0]

    removeConformer: (id) ->
      @conformers = (conformer in @conformers if conformer.id != id)

    clearConformers: () ->
      @conformers = []

    addConformer: (conformer, assignId = false) ->
      if conformer.getNumAtoms() != @getNumAtoms()
        throw new Exceptions.AtomNumberMismatchException()
      if assignId
        conformer.id = _.maxBy(@conformers, (conf) -> conf.id) + 1
      conformer.setOwningMol this
      @conformers.push conformer
      return conformer.id

    getNumConformers: () -> @conformers.length

    getRingInfo: () -> @ringInfo

    getTopology: () -> @graph

    clearComputedProps: (includeRings = true) ->
      #TODO: implement
      return

    updatePropertyCache: (bool strict = true) ->
      #TODO: implement
      return

    needsUpdatePropertyCache: () ->
      #TODO: implement
      return

    addAtom: (atom, updateLabel = true, takeOwnership = false) ->
      if not takeOwnership
        atomP = atom.copy()
      else
        atomP = atom
      atomP.setOwningMol this
      idx = @graph.addVertex atomP
      atomP.index = idx
      if updateLabel
        @replaceAtomBookmark atomP, Constants.ci_RIGHTMOST_ATOM
      for conformer in @conformers
        conformer.setAtomPos idx, [0.0, 0.0, 0.0]
      return idx

    getActiveAtom: () ->
      if @hasAtomBookmark Constants.ci_RIGHTMOST_ATOM
        return @getAtomWithBookmark Constants.ci_RIGHTMOST_ATOM
      else
        return @getLastAtom()

    setActiveAtom: (atom) ->
      @clearAtomBookmark Constants.ci_RIGHTMOST_ATOM
      @setAtomBookmark atom, Constants.ci_RIGHTMOST_ATOM

    replaceAtom: (idx, atom, updateLabel = false) ->
      numVertices = @graph.getNumVertices()
      if not (0 <= idx < numVertices)
        throw new Exceptions.IncorrectAtomIndexException bond.beginAtomIdx
      atomP = atom.copy()
      atomP.setOwningMol this
      atomP.index = idx
      @graph.vertices[idx] = atomP

    removeAtom: (atom) ->
      if not atom.owningMol.equal(this)
        throw new Exceptions.IncorrectOwnershipException()
      @graph.removeVertex(atom)

    removeBond: (idx1, idx2) ->
      if not _.isInteger(idx1) or 0 <= idx1 < @getNumAtoms()
        throw new Exceptions.IncorrectAtomIndexException idx1
      if not _.isInteger(idx2) or 0 <= idx2 < @getNumAtoms()
        throw new Exceptions.IncorrectAtomIndexException idx2
      bond = @getBondBetweenAtoms idx1, idx2
      if not bond or not bond.owningMol.equal this
        throw new Exceptions.IncorrectOwnershipException()
      #TODO: remove any bookmarks which point to this bond
      getBondBetweenAtoms(v, idx2)?.stereoAtoms = [] for v in @getAtomNeighborsIdx(idx1) when v isnt idx2
      getBondBetweenAtoms(v, idx1)?.stereoAtoms = [] for v in @getAtomNeighborsIdx(idx2) when v isnt idx1
      @ringInfo.reset()

    getLastAtom: () -> @getAtomWithIdx(@getNumAtoms()-1)

    addBond: (bond, takeOwnership = false) ->
      numVertices = @graph.getNumVertices()
      if not ( -1 < bond.beginAtomIdx < numVertices)
        throw new Exceptions.IncorrectAtomIndexException bond.beginAtomIdx
      if not ( -1 < bond.endAtomIdx < numVertices)
        throw new Exceptions.IncorrectAtomIndexException bond.endAtomIdx
      if bond.beginAtomIdx == bond.endAtomIdx
        throw new SelfBondException bond.endAtomIdx
      if takeOwnership
        bondP = bond.copy()
      else
        bondP = bond
      bondP.setOwningMol(this)
      idx = @graph.addEdge(bond.beginAtomIdx, bond.endAtomIdx, bond)
      if not _.isInteger(idx)
        throw new Exceptions.AddBondException()
      bondP.index = idx
      return idx

    createPartialBond: (idx, bondType) ->
      if not (0 <= idx < @graph.getNumVertices())
        throw new Exceptions.IncorrectAtomIndexException idx
      bond = new Bond bondType
      bond.setOwningMol this
      bond.setBeginAtomIdx idx
      return bond

    finishPartialBond: (idx, bondBookmark, bondType) ->
      if not @hasBondBookmark bondBookmark
        throw new Exceptions.NoPartialBondException()
      if not (0 <= idx < @graph.getNumVertices())
        throw new Exceptions.IncorrectAtomIndexException idx
      bond = @getBondWithBookmark bondBookmark
      if bondType is BondType.UNSPECIFIED
        bondType = bond.bondType
      @addBond bond, idx, bondType

    clear: () ->
      @graph = new Graph()
      @atomBookmarks = {}
      @bondBookmarks = {}
      @ringInfo = new RingInfo()
      @conformers = []
      @properties = {}

    insertMol: (mol) ->
      return

    setAtomBookmark: (atom, mark) ->
      if _.isInteger atom
        idx = atom
      else
        idx = atom.index
      @atomBookmarks[mark].push idx

    replaceAtomBookmark: (atom, mark) ->
      if _.isInteger atom
        idx = atom
      else
        idx = atom.index
      @atomBookmarks[mark] = [idx]

    getAtomWithBookmark: (mark) -> @getAtomWithIdx(_.head(@atomBookmarks[mark]))

    getAllAtomsWithBookmark: (mark) -> @getAtomWithIdx(idx) for idx in @atomBookmarks[mark]

    clearAtomBookmark: (mark, atom) ->
      if not atom
        delete @atomBookmarks[mark]
      else
        _.remove @atomBookmarks[mark], atom

    clearAllAtomBookmarks: () -> @atomBookmarks = {}

    hasAtomBookmark:(mark) -> mark of @atomBookmarks

    getAtomBookmarks: () -> @atomBookmarks

    setBondBookmark: (bond, mark) ->
      if _.isInteger(bond)
        idx = bond
      else
        idx = bond.index
      @bondBookmarks[mark].push idx

    getBondWithBookmark: (mark) -> @getBondWithIdx(_.head(@bondBookmarks[mark]))

    getAllBondsWithBookmark: (mark) -> @getBondWithIdx(idx) for idx in @bondBookmarks[mark]

    clearBondBookmark: (mark, bond) ->
      if not bond
        delete @bondBookmarks[mark]
      else
        _.remove(@bondBookmarks[mark], bond)

    clearAllBondBookmarks: () -> @bondBookmarks = {}

    hasBondBookmark: (mark) -> mark of @bondBookmarks

    getBondBookmarks: () -> @bondBookmarks

  exports.Molecule = Molecule