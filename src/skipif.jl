export @skipif

immutable Skipped end

macro skipif(pred::Union(Expr, Bool, Symbol), test::Expr)
  const name = test.args[1].args[1]
  quote
    if $(esc(pred))
      const $(esc(name)) = Skipped()
    else
      $(esc(test))
    end
  end
end

push_test!(tests::Vector{Tuple{AbstractString, Function}}, name::AbstractString, test::Skipped) = push!(tests, (name, () -> (true, :yellow, "$name SKIPPED")))
