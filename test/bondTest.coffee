requirejs = require "requirejs"
requirejs.config {
  baseUrl: './assets/js',
  nodeRequire: require
}

chai = require 'chai'
chai.should()

describe 'Testing Bond', ->
  Isotopes = null
  Elements = null
  Atom = null
  BondType = null
  Bond = null

  before (done) ->
    requirejs ['core/atom', 'core/bond_type', 'core/bond', 'core/isotope', 'core/element'], (atom, bond_type, bond, isotope, elements) ->
      Isotopes = isotope()
      Elements = elements
      Atom = atom
      BondType = bond_type
      Bond = bond
      done()

  describe 'Creating the Bond object', ->
    it 'can be created from bond type', ->
      b = new Bond BondType.UNSPECIFIED
    it 'can be created with a default bond type', ->
      b = new Bond()