export @testmodule

macro testmodule(name::Symbol, ex::Expr)
  const make_module = Expr(:module, true, esc(name), esc(ex))
  const post_process = :(collect_module($(esc(name))))
  return Expr(:toplevel, make_module, post_process)
end
