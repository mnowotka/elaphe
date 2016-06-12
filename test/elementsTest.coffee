requirejs = require "requirejs"
requirejs.config {
  baseUrl: './assets/js',
  nodeRequire: require
}

chai = require 'chai'
chai.should()

describe 'Testing Elements', ->
  Elements = null
  before (done) ->
    requirejs ['core/element'], (elements) ->
      Elements = elements
      done()

  describe 'Element and isotope information', ->
    it 'should contain Carbon', ->
      Elements.should.have.property 'C'
    it 'should have a correct symbol', ->
      carbon = new Elements.Element 'C'
      carbon.properties.symbol.should.equal 'C'
    it 'should have a isotopes', ->
      Elements.C.isotopes.should.have.length 15
    it 'should be able to return Isotope class instance', ->
      (Elements.C.getIsotope 16).properties.id.should.equal 'C16'
    it 'should be able to return a collection of Isotope instances', ->
      isotopes = Elements.C.getIsotopes()
      isotopes.should.have.length 15