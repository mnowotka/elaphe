define ['exports', 'core/element', 'core/periodic_table', 'core/isotope', 'core/stereo', 'core/hybridization_type', 'core/exceptions',
  'lodash'], (exports, Elements, PeriodicTable, Isotopes, Stereo, Hybridization, Exceptions, _) ->

  class Atom
    organic_subset = ['Xx', 'B', 'C', 'N', 'O', 'P', 'S', 'F', 'Cl', 'Br', 'I']
    potentially_aromatic = ['B', 'C', 'N', 'O', 'P', 'S', 'Se', 'As']
    constructor: (what) ->
      @atomicSymbol = null
      @isotope = null
      @charge = 0
      @explicitHydrogens = 0
      @stereo = Stereo.CHI_UNSPECIFIED
      @index = 0
      @radicalElectrons = 0
      @noImplicit = false
      @isAromatic = false
      @hybrid = Hybridization.UNSPECIFIED
      @implicitValence = -1
      @explicitValence = -1
      @owningMol = null

      if what instanceof Elements.Element
        @atomicSymbol = what.properties.symbol
      else if what instanceof Isotopes().Isotope
        @atomicNumber = what.getElement().properties.symbol
        @isotope = what.properties.id
      else if _.isString what
        if what of Elements
          @atomicSymbol = what
        else if what of Isotopes()
          @isotope = what
          @atomicSymbol = Isotopes()[what].atomicSymbol
        else
          throw new Exceptions.FormatException what
      else
        throw new Exceptions.IncorrectArgumentTypeException arguments

    copy: ->
      ret = new Atom(@atomicSymbol)
      ret.owningMol = null
      ret.index = 0
      ret.charge = @charge
      ret.noImplicit = @noImplicit
      ret.isAromatic = @isAromatic
      ret.explicitHydrogens = @explicitHydrogens
      ret.radicalElectrons = @radicalElectrons
      ret.setIsotope(@isotope)
      ret.stereo = @stereo
      ret.hybrid = @hybrid
      ret.implicitValence = @implicitValence
      ret.explicitValence = @explicitValence
      return ret

    setOwningMol: (mol) -> @owningMol = mol

    getOwningMol: -> @owningMol

    isOrganic: -> @getElement().properties.symbol in organic_subset

    isEarlyAtom: -> (4 - @getElement().properties.outshellElectrons) > 0

    getProps: -> _.extend {}, @getElement().properties, @getIsotope().properties

    getAtomicNumber: ->
      switch @atomicSymbol
        when 'C' then 6
        when 'N' then 7
        when 'O' then 8
        when 'H' then 1
        else @getElement().properties.atomicNumber

    getDegree: -> @owningMol?.getAtomDegree this

    getTotalDegree: -> if @owningMol then (@getTotalNumHs(false) + @getDegree()) else undefined

    getTotalNumHs: (includeNeighbors) ->
      if not @owningMol
        return
      res = @getNumExplicitHs() + @getNumImplicitHs()
      if includeNeighbors
        res += (n for n in @owningMol.getAtomNeighbors(this) when n.atomicSymbol is 'H').length
      return res

    getNumImplicitHs: ->
      @getImplicitValence()

    getNumExplicitHs: ->
      @explicitHydrogens

    getTotalValence: ->
      if not @owningMol
        return
      @getExplicitValence() + @getImplicitValence()

    getExplicitValence: ->
      if @explicitValence != (-1)
        return @explicitValence
      if not @owningMol
        return
      return @calcExplicitValence()

    getImplicitValence: ->
      if @noImplicit
        return 0
      if @implicitValence != (-1)
        return @implicitValence
      if not @owningMol
        return
      return @calcImplicitValence()

    calcExplicitValence: (strict) ->
      if not @owningMol
        return
      el = @getElement()
      valens = el.properties.valences
      accum = _.sum (bond.getValenceContrib(this) for bond in @getOwningMol().getAtomBonds(this))
      accum += @getNumExplicitHs()
      dv = el.getDefaultValence()
      chr = @charge
      if @isEarlyAtom()
        chr = -chr
      if @atomicSymbol is 'C' and chr > 0
        chr = -chr
      if accum > (dv + chr) and @isAromatic
        pval = dv + chr
        if not _.isEmpty(valens)
          for v in valens
            val = v + chr
            if val > accum
              break
            pval = val
        accum = pval
      accum += 0.1
      res = Math.round(accum)
      if strict
        effectiveValence = null
        if el.properties.outshellElectrons >= 4
          effectiveValence = res - @charge
        else
          effectiveValence = res + @charge
        maxValence = _.last(valens) ? 0
        if maxValence > 0 and effectiveValence > maxValence
          msg = "Explicit valence for atom # " + @index +  " " + el.properties.symbol + ", " + effectiveValence +
            ", is greater than permitted"
          throw Exceptions.MolSanitizeException(msg)
      @explicitValence = res
      return res

    calcImplicitValence: (strict) ->
      if @noImplicit
        return 0
      if not @owningMol
        return
      el = @getElement()
      valens = el.properties.valences
      if @explicitValence is -1
        @calcExplicitValence strict
      dv = el.getDefaultValence()
      if dv == 0
        return dv
      explicitPlusRadV = @getExplicitValence() + @radicalElectrons
      chr = @charge
      if @isEarlyAtom()
        chr = -chr
      if @atomicSymbol is 'C' and chr > 0
        chr = -chr
      if @isAromatic
        if explicitPlusRadV <= (dv + chr)
          res = dv + chr - explicitPlusRadV
        else
          satis = _.some valens, (v) -> explicitPlusRadV is (v + chr)
          if strict and not satis
            msg = "Explicit valence for aromatic atom # " + @index + " not equal to any accepted valence\n"
            throw Exceptions.MolSanitizeException(msg)
          res = 0
      else
        res = -1
        for v in valens
          tot = v + chr
          if explicitPlusRadV <= tot
            res = tot - explicitPlusRadV
            break
        if res < 0
          if strict
            throw "Explicit valence for atom # " + @index + " " + el.properties.symbol + " greater than permitted"
          else
            res = 0
      @implicitValence = res
      return res

    getMass: ->
      if @isotope
        return @getIsotope().properties.exactMass
      @getElement().properties.mass

    setIsotope: (what) ->
      if _.isString what
        if what of Isotopes()
          @isotope = what
        else
          throw new Exceptions.FormatException what

    getIsotope: ->
      return Isotopes()[@isotope]

    getElement: ->
      Elements[@atomicSymbol]

    invertChirality: ->
      if @stereo is Stereo.CHI_TETRAHEDRAL_CW
        @stereo = Stereo.CHI_TETRAHEDRAL_CCW
      else if @stereo is Stereo.CHI_TETRAHEDRAL_CCW
        @stereo = Stereo.CHI_TETRAHEDRAL_CW

    toString: ->
      if @atomicSymbol in organic_subset not @noImplicit and
          @charge is 0 and not @isotope and @stereo is Stereo.CHI_UNSPECIFIED
        return @atomicSymbol
      ret = '['
      if @isotope
        ret += @getIsotope().properties.number
      ret += @atomicSymbol
      if @stereo
        ret += @stereo.toString()
      if @charge
        if @charge is 1
          ret += '+'
        if @charge is (-1)
          ret += '-'
        if @charge > 0
          ret += '+' + @charge
        if @charge < 0
          ret += '-' + @charge
      ret += ']'
      return ret

  exports.Atom = Atom