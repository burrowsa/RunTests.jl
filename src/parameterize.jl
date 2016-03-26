export @parameterize

using Base.Meta

macro parameterize(params::Union{Expr, Symbol}, test::Expr)
  const name = test.args[1].args[1]
  const args = test.args[1].args[2:end]
  const body = test.args[2]
  const func_expr = Expr(:function, Expr(:tuple, args...), body)

  quote
    const $(esc(name)) = Parameterize($(esc(func_expr)), $(esc(params)))
  end
end

immutable Parameterize
  fn::Function
  params::Any
end

function push_test!(tests::Vector{Tuple{AbstractString, Function}}, name::AbstractString, test::Parameterize)
  for params in test.params
    push_test!(tests, "$(name)[$params]", ()->test.fn(params...))
  end
end
