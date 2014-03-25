function findtestfiles(path::String)
  # We may be called from the package directory or the test directory
  if (!isdir(path) || path==".") && isdir(joinpath("test", path)) && basename(pwd())!="test"
    path = joinpath("test", path)
  end
  return String[collect(Task() do
    for filename in readdir(path)
      filepath = abspath(path, filename)
      if isfile(filepath) && endswith(lowercase(filename), ".jl") && filename!="runtests.jl"
        produce(filepath)
      elseif isdir(filepath)
        for file in findtestfiles(filepath)
          produce(file)
	end
      end
    end
  end)...] # I'm told this elipsis is redundant but it really isn't
end
