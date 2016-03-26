if VERSION > v"0.5-" && isdefined(Base,:displaysize)
    tty_cols = Base.displaysize()[2]
else
    tty_cols = Base.tty_size()[2]
end

function set_tty_cols(val::Integer)
  global tty_cols = val
end

show_backtraces = true

function set_show_backtraces(val::Bool)
  global show_backtraces = val
end

function stringify_error(err, bt)
  const buff = IOBuffer()
  if show_backtraces
    showerror(buff, err, bt)
  else
    showerror(buff, err)
  end
  return UTF8String(buff.data)
end

function centre(message::AbstractString, padwith::Char='=')
  const padding = max(0, tty_cols - (length(message)+2))
  const padstr = "$padwith"
  return "$(padstr^round(Int,ceil(padding/2))) $message $(padstr^round(Int,floor(padding/2)))"
end

function underline(message::AbstractString, underlinewith::Char='=')
  const underlinestr = "$underlinewith"
  return "$message\n$(underlinestr^length(message))"
end

function breakwater(padwith::Char='=')
  return "$padwith"^tty_cols
end
