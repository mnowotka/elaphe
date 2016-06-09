define ->
  {
  IncorrectArgumentTypeException: (value) ->
    @message = "Unexpected type of argument " + value
    @toString =>
      @message
    return
  }

