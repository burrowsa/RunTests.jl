function findtestfiles(path::String)
  return String[collect(Task() do
    for filename in readdir(path)
      filepath = joinpath(path, filename)
      if isfile(filepath) && endswith(lowercase(filename), ".jl")
        produce(filepath)
      elseif isdir(filepath)
        for file in findtestfiles(filepath)
          produce(file)
	end
      end
    end
  end)...] # I'm told this elipsis is redundant but it really isn't
end
