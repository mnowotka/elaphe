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

