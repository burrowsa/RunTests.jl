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

  function test_foo()
    println("seen")
    @test true
    println("also seen")
    error("boo")
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

end