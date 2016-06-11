define ['core/periodic_table', 'core/isotopes', 'core/exceptions',
  'lodash'], (PeriodicTable, Isotopes, Exceptions, _) ->
  class Element
    constructor: (id) ->
      if _.isInteger id
        @properties = PeriodicTable.atoms[id]
      else if _.isString id
        @properties = _.find PeriodicTable.atoms, (obj) -> obj.symbol is id
      else
        throw new Exceptions.IncorrectArgumentTypeException id
      if @properties
        @isotopes = Isotopes[@properties.symbol]

    getIsotope: (idx) ->
      return
        
    toString: -> @properties.symbol

  elements = _.map PeriodicTable.atoms, (el) ->
    ret = {}
    ret[el.symbol] = new Element el.symbol
    return ret

  elements = _.extend {}, elements..., {'Element': Element}
  return elements


