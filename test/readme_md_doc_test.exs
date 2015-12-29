path = Path.expand("../../tmp/beams", __DIR__)
File.rm_rf!(path)
File.mkdir_p!(path)
Code.prepend_path(path)

defmodule ReadmeMdDocTest do
  use ExUnit.Case, async: :true
  doctest ReadmeMdDoc

  def gen({:module, name, bin, _}, opts \\ []) do
    File.mkdir_p!(unquote(path))
    beam_path = Path.join(unquote(path), Atom.to_string(name) <> ".beam")
    File.write!(beam_path, bin)
    ReadmeMdDoc.generate(name, opts) |> List.to_string()
  end

  def contains(doc, string) do
    assert String.contains?(doc, string), "#{string} not in #{doc}"
  end
  def not_contains(doc, string) do
    refute String.contains?(doc, string), "unexpected #{string} in #{doc}"
  end

  test "docstrings" do
    res = gen(defmodule T do
      @moduledoc "_MD_"

      @typedoc "_TD_"
      @type fb :: :foo | :bar

      @doc "_CB_"
      @callback cb(arg :: fb) :: any

      @doc "_MAC_"
      defmacro mac() do :ok end

      @doc "_FN_"
      def dfn() do :foo end
    end)
    ~w(_MD_ _TD_ _CB_ _MAC_ _FN_) |>
      Enum.map(fn(docstring) ->
        contains(res, docstring)
      end)
  end

  test "sections" do
    res = gen(defmodule CF do
      @callback foo(arg :: any) :: any
      @typep goop :: {any, :ok}
      @spec bar(goop) :: :ok
      def bar(_), do: :ok
    end)
    contains(res, "Callbacks")
    contains(res, "Functions")
    not_contains(res, "Types")
    not_contains(res, "Macros")

    res = gen(defmodule TM do
      @type foo :: :foo
      defmacro bar(), do: :bar
      @doc :false
      def foo(), do: "what?"
    end)
    not_contains(res, "Callbacks")
    not_contains(res, "Functions")
    contains(res, "Types")
    contains(res, "Macros")
  end

  test "about" do
    res = gen(defmodule About do
      @moduledoc "T"
    end, about: "_ABOUT_")
    contains(res, "_ABOUT_")
  end

  test "order" do
    res = gen(defmodule Order do
      @moduledoc "_MD_"
      @type food :: :apple | :pear | :jackfruit
      @callback eat(food :: food) :: :ok | :nope
      def digest(food), do: "#{food} = yum yum"
    end, order: [:title, :callback, :def])
    not_contains(res, "Types")
    not_contains(res, "_MD_")
    {title_pos, _} = :binary.match(res, "Order")
    {cb_pos, _} = :binary.match(res, "Callbacks")
    {func_pos, _} = :binary.match(res, "Functions")
    assert title_pos < cb_pos
    assert cb_pos < func_pos
  end
end
