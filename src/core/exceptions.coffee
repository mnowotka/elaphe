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

    IncorrectElementIndexException: (idx) ->
      @message = "Incorrect element index " + idx
      @toString =>
        @message
      return

    NoOwningMolException: (atom) ->
      @message = "No owning molecule defined for atom" + atom
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

