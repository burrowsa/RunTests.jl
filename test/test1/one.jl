using RunTests
using Base.Test

@testmodule FirstSetOfTests begin

  x = 100

  function test_apple()
      @test true
  end

  function test_aardvark()
      @test true
  end

  function test_andrew()
    @test true
  end

  function foo()
    @test x==100
  end

  test_hello() = foo()

  function test_world()
    println("seen")
    @test true
    println("also seen")
    @test false
    println("never seen")
    @test 100==100
  end

  function test_bar()
    println("seen")
    @test true
    println("also seen")
    @test error("boo")
    println("never seen")
    @test 100==100
  end

  function test_baz()
    @test false
  end

  @skipif false function test_not_skipped()
    @test true
  end

  @skipif true function test_skipped()
    @test true
  end

  const SKIP_FALSE = false

  @skipif SKIP_FALSE function test_not_skipped_constant()
    @test true
  end

  const SKIP_TRUE = true

  @skipif SKIP_TRUE function test_skipped_constant()
    @test true
  end

  @skipif (x->x)(100+25/5)==102+25/5 function test_not_skipped_complex()
    @test true
  end

  @skipif (x->x)(100+25/5)==100+25/5 function test_skipped_complex()
    @test true
  end

  @xfail function test_xfails()
    @test false
  end

  @xfail function test_xpasses()
    @test true
  end

  @parameterize 1:4 function test_parameterised(x)
    @test x<3
  end

  @parameterize [1,2,3,4] function test_parameterised_with_types(x::Integer)
    @test x<3
  end

  @parameterize [(1,4),(2,3),(3,2),(4,1)] function test_parameterised_2_args(x::Integer, y::Any)
    @test x<y
  end

  @parameterize zip(1:4,4:-1:1) function test_parameterised_zip(x::Integer, y::Any)
    @test x<y
  end

  const CONST_PARAMS = [1,2,3,4]

  @parameterize CONST_PARAMS function test_parameterised_constant(x)
    @test x<3
  end

end
