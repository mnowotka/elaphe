define ['exports', 'core/exceptions', 'lodash'], (exports, Exceptions, _) ->

  class Conformer
    constructor: (numAtoms) ->
      @is3D = true
      @id = 0
      @owningMol = null
      if _.isInteger numAtoms
        @positions = _.fill(Array(numAtoms), [0.0, 0.0, 0.0]);
      else
        @positions = []

    copy: ->
      ret = new Conformer()
      ret.is3D = @.is3D
      ret.id = @id
      ret.positions = _.clone @positions
      ret.owningMol = null

    getOwningMol: -> @owningMol

    getPositions: ->
      if @owningMol.getNumAtoms() != @positions.length
        throw new Exceptions.AtomNumberMismatchException()
      @positions

    getAtomPos: (atomId) ->
      if @owningMol.getNumAtoms() != @positions.length
        throw new Exceptions.AtomNumberMismatchException()
      if not ( -1 < atomId < @positions.length)
        throw new Exceptions.IncorrectAtomIndexException atomId
      @positions[atomId]

    setAtomPos: (atomId, position) ->
      if atomId >= @positions.length
        @positions = _.concat @positions, _.fill(Array(atomId - @positions.length + 1), [0.0, 0.0, 0.0])
      @positions[atomId] = position

    getNumAtoms: () -> @positions.length
