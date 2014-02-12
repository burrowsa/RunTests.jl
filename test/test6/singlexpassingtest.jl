using RunTests
using Base.Test

@testmodule TestModuleWithOneXPassingTest begin

@xfail function test_xpassing()
  @test true
end

end