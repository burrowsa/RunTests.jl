using RunTests
using Base.Test

@testmodule TestModuleWithOnePassingTest begin

  function test_hello()
    @test true
  end

end