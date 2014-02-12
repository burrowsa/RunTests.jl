export @xfail

immutable XFail
  fn::Function
end

macro xfail(test::Expr)
  const name = test.args[1].args[1] #TODO: make this robust
  const body = test.args[2] #TODO: make this robust
  quote
    const $(esc(name)) = XFail() do
                           $(esc(body))
                         end
  end
end

function push_test!(tests::Vector{(String, Function)}, name::String, test::XFail)
  function run_test()
    try
      test.fn()
      return false, :green, "$name XPASSED"
    catch
      return true, :red, "$name XFAILED"
    end
  end
  push!(tests, (name, run_test))
end
