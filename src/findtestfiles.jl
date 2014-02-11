function findtestfiles(path::String)
  return String[collect(Task() do
    for filename in readdir(path)
      filepath = joinpath(path, filename)
      if isfile(filepath) && endswith(lowercase(filename), ".jl")
        produce(filepath)
      elseif isdir(filepath)
        map(produce, findtestfiles(filepath))
      end
    end
  end)...] # I'm told this elipsis is redundant but it really isn't
end
