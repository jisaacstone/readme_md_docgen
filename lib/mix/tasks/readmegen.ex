defmodule Mix.Tasks.ReadmeGen do
  use ArgumentParser.Builder.Mix
  @shortdoc """
  Generate a README.md for your elixir project
  """

  @moduledoc @shortdoc <> """

  Usage:

      mix readme_gen MyModule [MyModule.Other ...] [options]

  options:
  
  * `-f --filename NAME` -> Name of file to write. Default: `README.md`
  * `-a --append` -> Append to file instead of overwriting.
  * `-h --help` -> Print detailed help message.
  """

  @arg [:module,
        action: {:append, :+, &ReadmeMdDoc.to_mod/1},
        required: :true]
  @flag [:filename, alias: :f, default: "README.md"]
  @flag [:append, action: :store_true, help:
         "Append to existing file instead of overwriting"]

  @doc :false
  def main(args) do
    mode = if args.append, do: :append, else: :write
    fob = File.open!(args.filename, [:utf8, mode])
    try do: generate(args.module, fob), after: File.close(fob)
  end

  defp generate(mods, fob) do
    doc = ReadmeMdDoc.generate(mods)
    IO.write(fob, doc)
  end
end
