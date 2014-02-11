export @testmodule

macro testmodule(name::Symbol, ex::Expr)
  # TODO: I could put a handler inside the module so that
  # it errors if any tests are hit during module declaration
  # to stop people mixing styles - is this a good ideas?
  const make_module = Expr(:module, true, esc(name), esc(ex))
  const post_process = :(collect_module($(esc(name))))
  return Expr(:toplevel, make_module, post_process)
end
