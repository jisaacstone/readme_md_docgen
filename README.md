[`ReadmeMdDoc`](#ReadmeMdDoc)

[`Mix.Tasks.ReadmeGen`](#Mix.Tasks.ReadmeGen)

<a name="ReadmeMdDoc"></a>
# ReadmeMdDoc

* [Description](#description)
* [Functions](#functions)

## Description <a name="description"></a>

Generate markdown documentation for your elixir projects.

Parses attributes and specs using `ex_doc` and generates pretty markdown
with internal anchors and links.

## Functions <a name="functions"></a>

### generate(modules, config) <a name="generate/2"></a>

Generate markdown documentation for a module or list of modules.

Options    |
-----------|---
`:order`   | Sections to be included in order. Default:
           | `[:title, :about, :links, :moduledoc, :typespecs, :def, :defmacro, :callback]`
`:about`   | Any additional information you'd like to be included.

if multiple modules are included then a header with links to the documentation
for each will be generated as well.


### generate(module) <a name="generate/1"></a>

Calls generate/2 with default config

<a name="Mix.Tasks.ReadmeGen"></a>
# Mix.Tasks.ReadmeGen

## Description

Generate a README.md for your elixir project
Usage:

    mix readme_gen MyModule [MyModule.Other ...] [options]

options are:

* `-f --filename NAME` -> Name of file to write. Default: `README.md`
* `-a --append` -> Append to file instead of overwriting.
* `-h --help` -> Print detailed help message.
