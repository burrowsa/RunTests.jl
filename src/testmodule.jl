export @testmodule

macro testmodule(name::Symbol, ex::Expr)
  const body = Expr(:block,
                    :(eval(x) = Core.eval($name, x)),
                    :(eval(m,x) = Core.eval(m, x)),
                    ex.args...)
  const make_module = Expr(:module, true, esc(name), esc(body))
  const post_process = :(collect_module($(esc(name))))
  return Expr(:toplevel, make_module, post_process)
end
