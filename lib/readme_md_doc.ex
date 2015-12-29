defmodule ReadmeMdDoc do
  @moduledoc """
  Generate markdown documentation for your elixir projects.

  Parses attributes and specs using `ex_doc` and generates pretty markdown
  with internal anchors and links.
  """

  @doc "Calls generate/2 with default config"
  def generate(module), do: generate(module, [])

  @doc """
  Generate markdown documentation for a module or list of modules.

  Options:

  * `:order` -> Sections to be included in order. Default:
               `[:title, :about, :links, :moduledoc, :typespecs, :def, :defmacro, :callback]`
  * `:about` -> Any additional information you'd like to be included.

  if multiple modules are included then a header with links to the documentation
  for each will be generated as well.
  """
  @spec generate(atom | binary | [atom] | [binary], Dict.t) :: iodata
  def generate([module], config), do: generate(module, config)
  def generate(modules, config) when is_list(modules) do
    {head, config} = ReadmeMdDoc.Formatter.mm_head(modules, config)
    config = Dict.put(config, :link_title, :true)
    body = Enum.map(modules, &generate(&1, config))
    [head | body]
  end
  def generate(module, config) when is_binary(module) do
    generate(to_mod(module), config)
  end
  def generate(module, config) do
    ExDoc.Retriever.docs_from_modules([module], %ExDoc.Config{}) |>
      ExDoc.Formatter.HTML.Autolink.all() |>
      hd() |>
      ReadmeMdDoc.Formatter.format(config)
  end

  @doc :false
  def to_mod(mod_name) when is_binary(mod_name) do
    String.to_atom("Elixir." <> mod_name)
  end
end
