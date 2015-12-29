use Mix.Config

config :readme_md_doc,
  modules: [ReadmeMdDoc, Mix.Tasks.ReadmeGen],
  about: """
  _mix_

  Simply add to your mix.exs as a dependency:

      def deps do
        [{:readme_md_doc, "~> 0.1", only: :dev}]
      end

  Now generate your docs with `mix readme_gen <modules>`

  _config_

  You can set options in your config.exs.

      config :readme_md_doc, about: \"""
        Some extra thing about your poject
        that will be inclueded in generated docs
      \"""
  """
