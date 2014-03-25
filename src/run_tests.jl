export run_tests

using ProgressMeter

show_progress = true

function set_show_progress(val::Bool)
  global show_progress = val
end

# We use a GUID to make sure that we don't accidentaly collide with other
# values in task_local_storage
const COLLECT_MODULE = :fixtures_runtests_collect_module_75dc91fb0fb74aef840d4c36c0c6ee69

function collect_module(m::Module)
  # If we have collector set then we'll call that if not we will run tests
  # this allows users to run individual modules directly while still allowing
  # defered execution.
  const func = try
                 task_local_storage(COLLECT_MODULE)
               catch
                 run_tests
               end
  func(m)
end

push_test!(tests::Vector{(String, Function)}, name::String, test::Any) = Nothing

function push_test!(tests::Vector{(String, Function)}, name::String, test::Function)
  function run_test()
    test()
    return true, :green, "$name PASSED"
  end
  push!(tests, (name, run_test))
end

run_tests(testdir::String=".") = run_tests(findtestfiles(testdir))

function run_tests(filenames::Vector{String})
  function collector(m::Module)
    push!(test_modules, m)
  end

  const test_modules = Module[]
  task_local_storage(COLLECT_MODULE, collector) do
    for filename in filenames
      include(filename)
    end
  end
  run_tests(test_modules)
end

function run_tests(modules::Vector{Module})
  const tests = (String, Function)[]
  for m in modules, name in Base.names(m, true)
    val = getfield(m, name)
    if beginswith(string(name), "test_")
      push_test!(tests, "$m.$name", val)
      if show_progress
        ProgressMeter.printover("found $(length(tests)) tests...")
      end
    end
  end

  const pm = Progress(length(tests), 0, "Running $(length(tests)) tests ", 30)
  const results = (Bool, Symbol, String)[]
  const failures = (String, String, String)[]
  for (i, (name, test)) in enumerate(sort(tests, by=x->x[1]))
    _, output, err = capture_output() do
      push!(results, test())
    end

    if err!=Nothing
      push!(results, (false, :red, "$name FAILED"))
      push!(failures, (name, output, stringify_error(err, catch_backtrace())))
    end

    if show_progress
      next!(pm, all(x->x[1], results) ? :green : :red)
    end
  end

  const allok = isempty(results) || all(x->x[1], results)
  if !allok
    println("\n", underline("Tests:"), "\n")
    for (ok, color, result) in results
      print_with_color(color, result, "\n")
    end
  end

  if !isempty(failures)
    println("\n\n",centre("Failures"), "\n")
    for (name, output, err) in failures
      println("\n", centre("$name", '-'))
      println(err)
      if !isempty(output)
        println("\n", underline("Captured Output:"), "\n\n", output)
      end
      println("\n", breakwater('-'))
    end
  end

  if !isempty(results)
    const status_counts = Dict{String, Integer}()
    for (ok, colour, result) in results
      const status = lowercase(split(result)[end])
      status_counts[status] = get(status_counts, status, 0) + 1
    end
    const status_summary = join(["$count $status" for (status, count) in sort(collect(status_counts))], " ")
    println("\n", centre(status_summary), "\n")
  end

  return allok ? 0 : 1
end

run_tests(m::Module) = run_tests([m])
