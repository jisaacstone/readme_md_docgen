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

  @arg [:modules, metavar: "MODULE", action: {:store, :*, &ReadmeMdDoc.to_mod/1}]
  @flag [:filename, alias: :f, default: "README.md"]
  @flag [:append, action: :store_true, help:
         "Append to existing file instead of overwriting"]

  @doc :false
  def main(cm_args) do
    cf_args = Application.get_all_env(:readme_md_doc)
    args = Dict.merge(cf_args, cm_args)
    if args[:module] == [] do
      IO.puts("one or more module names required")
      exit(1)
    end
    mode = if args[:append], do: :append, else: :write
    fob = File.open!(args[:filename], [:utf8, mode])
    try do: generate(args[:modules], args, fob), after: File.close(fob)
  end

  defp generate(mods, args, fob) do
    doc = ReadmeMdDoc.generate(mods, args)
    IO.write(fob, doc)
  end
end
