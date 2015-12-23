defmodule ReadmeMdDoc.Mixfile do
  use Mix.Project

  def project, do:
    [ app: :readme_md_doc,
      version: "0.0.1",
      elixir: "~> 1.2-rc",
      source_url: "https://github.com/jisaacstone/readme_md_docgen",
      package: package,
      deps: deps,
      description: "README.md generation tool for small Elixir project" ]

  def application, do: []

  defp package, do:
   [ licenses: ["Apache 2.0"],
     links: %{"GitHub" => "https://github.com/jisaacstone/readme_md_docgen"} ]

  defp deps, do:
    [ {:ex_doc, "~> 0.11", only: :dev} ]

end
