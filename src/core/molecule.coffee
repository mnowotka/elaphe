define ['exports', 'core/element', 'core/periodic_table', 'core/isotope', 'core/stereo', 'core/hybridization_type',
  'core/bond_type', 'core/bond_direction', 'core_bond_stereo', 'core/bond',
  'core/atom', 'core/exceptions',
  'lodash'], (exports, Elements, PeriodicTable, Isotopes, Stereo, Hybridization, BondType, BondDirection, BondStereo, Bond, Atom, Exceptions, _) ->

  class Molecule
    constructor: ->
      return

    getNumAtoms: (onlyExplicit = 1) ->
      return

    getNumHeavyAtoms: ->
      return

    getAtomWithIdx: (idx) ->
      return

    getAtomDegree: (atom) ->
      return

    getNumBonds: (onlyHeavy = 1) ->
      return

    getBondWithIdx: (idx) ->
      return

    getBondBetweenAtoms: (idx1, idx2) ->
      return

    getConformer: (id = -1) ->
      return

    removeConformer: (id) ->
      return

    clearConformers: () ->
      return

    addConformer: (conformer, assignId = false) ->
      return

    getNumConformers: () ->
      return

    getRingInfo: () ->
      return

    getAtomNeighbors: () ->
      return

    getAtomBonds: () ->
      return

    getVertices: () ->
      return

    getEdges: () ->
      return

    getVertices: () ->
      return

    getTopology: () ->
      return

    clearComputedProps: (includeRings = true) ->
      return

    updatePropertyCache: (bool strict = true) ->
      return

    needsUpdatePropertyCache: () ->
      return

    addAtom: (atom, updateLabel = true, takeOwnership = false) ->
      return

    getActiveAtom: () ->
      return

    setActiveAtom: (atom) ->
      return

    replaceAtom: (idx, atom, updateLabel = false) ->
      return

    removeAtom: (what) ->
      return

    getLastAtom: () ->
      return

    addBond: (bond, takeOwnership = false) ->
      return

    createPartialBond: (idx, bondType) ->
      return

    finishPartialBond(idx, bondBookmark, bondType) ->
      return

    clear: () ->
      return

    insertMol: (mol) ->
      return

    setAtomBookmark: (atom, mark) ->
      return

    replaceAtomBookmark: (atom, mark) ->
      return

    getAtomWithBookmark: (mark) ->
      return

    getAllAtomsWithBookmark: (mark) ->
      return

    clearAtomBookmark: (mark) ->
      return

    clearAllAtomBookmarks: () ->
      return

    getAtomBookmarks: () ->
      return

    setBondBookmark: (bond, mark) ->
      return

    getBondWithBookmark: (mark) ->
      return

    getAllBondsWithBookmark: (mark) ->
      return

    clearBondBookmark: (mark, bond) ->
      return

    clearAllBondBookmarks: () ->
      return

    hasBondBookmark: (mark) ->
      return

    getBondBookmarks: () ->
      return

  exports.Molecule = Molecule