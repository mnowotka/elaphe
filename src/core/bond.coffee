define ['exports', 'core/element', 'core/periodic_table', 'core/isotope', 'core/stereo', 'core/hybridization_type',
  'core/bond_type', 'core/bond_direction', 'core_bond_stereo'
  'core/atom', 'core/exceptions',
  'lodash'], (exports, Elements, PeriodicTable, Isotopes, Stereo, Hybridization, BondType, BondDirection, BondStereo, Atom, Exceptions, _) ->
  class Bond

    constructor: (bondType) ->
      if not _.isInteger(bondType)
        throw new Exceptions.IncorrectArgumentTypeException bondType
      if bondType not in (_.values BondType)
        throw new Exceptions.UnrecognisedBondType bondType
      @bondType = bondType
      @isAromatic = false
      @isConjugated = false
      @direction = BondDirection.NONE
      @stereo = BondStereo.STEREONONE
      @index = -1
      @beginAtomIdx = -1
      @endAtomIdx = -1
      @owningMol = null
      @stereoAtoms = []

    copy: ->
      ret = new Bond(@bondType)
      ret.owningMol = null
      ret.beginAtomIdx = @beginAtomIdx
      ret.endAtomIdx = @endAtomIdx
      ret.direction = @direction
      ret.stereo = @stereo
      ret.isAromatic = @isAromatic
      ret.isConjugated = @isConjugated
      ret.index = @index
      if not _.isEmpty(@stereoAtoms)
        ret.stereoAtoms = _.clone @stereoAtoms
      else
        ret.stereoAtoms = []
      return ret

    getValenceContrib: (atom) ->
      return

    setOwningMol: (mol) -> @owningMol = mol

    getOwningMol: -> @owningMol

    getOtherAtomIdx: (thisIdx) ->
      if @beginAtomIdx is -1 or @endAtomIdx is -1
        return
      if thisIdx is @beginAtomIdx
        return @endAtomIdx
      if thisIdx is @endAtomIdx
        return @beginAtomIdx

    setBeginAtomIdx: (idx) ->
      if not @owningMol
        throw new Exceptions.NoOwningMolException
      if idx < @owningMol.getNumAtoms()
        @beginAtomIdx = idx
      else
        throw new Exceptions.IncorrectAtomIndexException idx

    setEndAtomIdx: (idx) ->
      if not @owningMol
        throw new Exceptions.NoOwningMolException
      if idx < @owningMol.getNumAtoms()
        @beginAtomIdx = idx
      else
        throw Exceptions.IncorrectAtomIndexException idx

    setBeginAtom: (atom) ->
      if not @owningMol
        throw new Exceptions.NoOwningMolException
      @setBeginAtomIdx atom.index

    setEndAtom: (atom) ->
      if not @owningMol
        throw new Exceptions.NoOwningMolException
      @setEndAtomIdx atom.index

    getBeginAtom: ->
      if not @owningMol or @beginAtomIdx is -1
        return
      @owningMol.getAtomWithIdx @beginAtomIdx

    getEndAtom: ->
      if not @owningMol or @endAtomIdx is -1
        return
      @owningMol.getAtomWithIdx @endAtomIdx

    getOtherAtom: (atom) ->
      if not @owningMol
        return
      idx = atom.index
      @getOtherAtomIdx idx

  exports.Bond = Bond