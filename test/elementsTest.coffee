requirejs = require "requirejs"
requirejs.config {
  baseUrl: './assets/js',
  nodeRequire: require
}

chai = require 'chai'
chai.should()

describe 'Testing', ->
  Elements = null
  before (done) ->
    requirejs ['core/element'], (elements) ->
      Elements = elements;
      done()

  describe 'Element and isotope information', ->
    it 'should contain Carbon', ->
      Elements.should.have.property('C')
    it 'should have a correct symbol', ->
      carbon = new Elements.Element('C')
      carbon.properties.symbol.should.equal('C')
    it 'should have a isotopes', ->
      Elements.C.isotopes.should.have.length(15)