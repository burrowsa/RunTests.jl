using RunTests
using Base.Test

@testmodule ThirdSetOfTests begin
  function test_hello()
    @test true
  end
end

@testmodule FourthSetOfTests begin
  function test_hello()
    @test true
  end
end