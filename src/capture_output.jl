function capture_output(fn::Function)
  # TODO: redirect_stdout and redirect_stderr look useful but I can't see a way to undo them
  const buff = IOBuffer()
  const OUT = Base.STDOUT
  const ERR = Base.STDERR
  Base.eval(:(STDOUT = $buff))
  Base.eval(:(STDERR = $buff))

  try
    return fn(), UTF8String(buff.data), Nothing
  catch err
    return Nothing, UTF8String(buff.data), err
  finally
    Base.eval(:(STDOUT = $OUT))
    Base.eval(:(STDERR = $ERR))
  end
end
