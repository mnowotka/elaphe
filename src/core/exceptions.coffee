define ->
  {
    IncorrectArgumentTypeException: (value) ->
      @message = "Unexpected type of argument " + value
      @toString =>
        @message
      return

    UnrecognisedElementSymbolException: (symbol) ->
      @message = "Unrecognized element symbol " + symbol
      @toString =>
        @message
      return

    UnrecognisedBondType: (type) ->
      @message = "Unrecognized bond type " + type
      @toString =>
        @message
      return      

    IncorrectElementIndexException: (idx) ->
      @message = "Incorrect element index " + idx
      @toString =>
        @message
      return

    IncorrectAtomIndexException: (idx) ->
      @message = "Incorrect atom index " + idx
      @toString =>
        @message
      return

    NoPartialBondException: ->
      @message = "No such partial bond"
      @toString =>
        @message
      return

    IncorrectOwnershipException: ->
      @message = "Can't delete the object from the molecule that dosn't belong to it. "
      @toString =>
        @message
      return

    SelfBondException: (idx) ->
      @message = "Incorrect bond with the same begin and end atom index " + idx
      @toString =>
        @message
      return

    AddBondException: (idx) ->
      @message = "Bond cannot be added"
      @toString =>
        @message
      return

    AtomNumberMismatchException: ->
      @message = "Atom index mismatch"
      @toString =>
        @message
      return

    IndexMismatchException: ->
      @message = "Index mismatch"
      @toString =>
        @message
      return      

    NotInitiatedException: ->
      @message = "Object not initiated"
      @toString =>
        @message
      return      

    NoOwningMolException: () ->
      @message = "No owning molecule defined"
      @toString =>
        @message
      return

    MolSanitizeException: (msg) ->
      @message = msg
      @toString =>
        @message
      return

    ParsingException: (value, type) ->
      @message = "Can parse " + value + " as " + type
      @toString =>
        @message
      return

    FormatException: (value) ->
      @message = value + " has a wrong format"
      @toString =>
        @message
      return
  }

