defmodule ReadmeMdDoc do
  @moduledoc """
  Create a README.md based on `@doc` annotations
  """

  @doc """
  Generate a markdown file for a module
  """
  @spec generate(Module.t, Dict.t) :: iodata
  def generate(module, config \\ []) do
    ExDoc.Retriever.docs_from_modules([module], %ExDoc.Config{}) |>
      ExDoc.Formatter.HTML.Autolink.all() |>
      hd() |>
      ReadmeMdDoc.Formatter.format(config)
  end
end
