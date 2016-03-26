function capture_output(fn::Function)
  const buff = IOBuffer()
  const OUT = Base.STDOUT
  const ERR = Base.STDERR
  Base.eval(:(STDOUT = $buff))
  Base.eval(:(STDERR = $buff))

  try
    return fn(), UTF8String(buff.data), nothing
  catch err
    return nothing, UTF8String(buff.data), err
  finally
    Base.eval(:(STDOUT = $OUT))
    Base.eval(:(STDERR = $ERR))
  end
end
