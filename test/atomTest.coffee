requirejs = require "requirejs"
requirejs.config {
  baseUrl: './assets/js',
  nodeRequire: require
}

chai = require 'chai'
chai.should()

describe 'Testing Atom', ->
  Isotopes = null
  Elements = null
  Atom = null
  before (done) ->
    requirejs ['core/atom', 'core/isotope', 'core/element'], (atom, isotope, elements) ->
      Isotopes = isotope()
      Elements = elements
      Atom = atom
      done()

  describe 'Creating the Atom object', ->
    it 'can be created from Element', ->
      a = new Atom Elements.C
      a.atomicSymbol.should.equal 'C'
    it 'can be created from Isotope', ->
      a = new Atom Isotopes.C16
      a.isotope.should.equal 'C16'
    it 'can be created from element string', ->
      a = new Atom 'C'
      a.atomicSymbol.should.equal 'C'
    it 'can be created from isotope string', ->
      a = new Atom 'C16'
      a.isotope.should.equal 'C16'