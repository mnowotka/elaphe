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

