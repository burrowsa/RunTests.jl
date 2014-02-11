tty_cols = Base.tty_cols()

function set_tty_cols(val::Integer)
  global tty_cols = val
end

function stringify_error(err, bt)
  const buff = IOBuffer()
  showerror(buff, err, bt)
  return UTF8String(buff.data)
end

function centre(message::String, padwith::Char='=')
  const padding = max(0, tty_cols - (length(message)+2))
  const padstr = "$padwith"
  return "$(padstr^int(ceil(padding/2))) $message $(padstr^int(floor(padding/2)))"
end

function underline(message::String, underlinewith::Char='=')
  const underlinestr = "$underlinewith"
  return "$message\n$(underlinestr^length(message))"
end

function breakwater(padwith::Char='=')
  return "$padwith"^tty_cols
end
