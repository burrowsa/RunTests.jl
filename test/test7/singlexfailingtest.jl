using RunTests
using Base.Test

@testmodule TestModuleWithOneXFailingTest begin

@xfail function test_xfailing()
  @test false
end

end