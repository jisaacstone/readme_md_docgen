[`Elixir.ReadmeMdDoc`](#Elixir.ReadmeMdDoc)

[`Elixir.Mix.Tasks.ReadmeGen`](#Elixir.Mix.Tasks.ReadmeGen)

_mix_

Simply add to your mix.exs as a dependency:

    def deps do
      [{:readme_md_doc, "~> 0.1", only: :dev}]
    end

Now generate your docs with `mix readme_gen <modules>`

_config_

You can set options in your config.exs.

    config :readme_md_doc, about: """
      Some extra thing about your poject
      that will be inclueded in generated docs
    """

# ReadmeMdDoc

<a name="ReadmeMdDoc"></a>

* [Description](#description)
* [Functions](#functions)

## Description <a name="description"></a>

Generate markdown documentation for your elixir projects.

Parses attributes and specs using `ex_doc` and generates pretty markdown
with internal anchors and links.

## Functions <a name="functions"></a>

### generate(modules, config) <a name="generate/2"></a>

Generate markdown documentation for a module or list of modules.

Options:

* `:order` -> Sections to be included in order. Default:
             `[:title, :about, :links, :moduledoc, :typespecs, :def, :defmacro, :callback]`
* `:about` -> Any additional information you'd like to be included.

if multiple modules are included then a header with links to the documentation
for each will be generated as well.


### generate(module) <a name="generate/1"></a>

Calls generate/2 with default config

# Mix.Tasks.ReadmeGen

<a name="Mix.Tasks.ReadmeGen"></a>

* [Description](#description)
* [Functions](#functions)

## Description <a name="description"></a>

Generate a README.md for your elixir project

Usage:

    mix readme_gen MyModule [MyModule.Other ...] [options]

options:

* `-f --filename NAME` -> Name of file to write. Default: `README.md`
* `-a --append` -> Append to file instead of overwriting.
* `-h --help` -> Print detailed help message.

## Functions <a name="functions"></a>

### run(args) <a name="run/1"></a>

