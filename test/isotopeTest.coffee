requirejs = require "requirejs"
requirejs.config {
  baseUrl: './assets/js',
  nodeRequire: require
}

chai = require 'chai'
chai.should()

describe 'Testing Isotope', ->
  Isotope = null
  Elements = null
  before (done) ->
    requirejs ['core/isotope', 'core/element'], (isotope, elements) ->
      Isotope = isotope().Isotope
      Elements = elements
      done()

  describe 'Creating the Isotope object', ->
    it 'can be created from isotope symbol', ->
      iso = new Isotope 'C16'
      iso.properties.id.should.equal 'C16'
    it 'can be created from atom and index', ->
      iso = new Isotope Elements.C, 16
      iso.properties.atomicNumber.should.equal 6
    it 'can be created from atomic number and index', ->
      iso = new Isotope 6, 16
      iso.properties.halfLife.should.equal 0.747
    it 'knows its Element', ->
      iso = new Isotope 'C16'
      iso.getElement().properties.symbol.should.equal 'C'