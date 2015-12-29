defmodule ReadmeMdDoc.Formatter do
  @funct [:def, :defmacro, :callback]
  @default_order [:title, :about, :links, :moduledoc, :typespecs] ++ @funct

  defmacrop ifs(condition, action) do
    quote do
      if unquote(condition) do
        unquote(action)
      else "" end
    end
  end

  @spec mm_head([atom], [term]) :: iodata
  def mm_head(modules, config) do
    links = Enum.map(modules, fn(mod) -> "[`#{mod}`](##{mod})\n\n" end)
    {about, conf} = Dict.pop(config, :about, :nil)
    print_about? = about != :nil and :about in Dict.get(conf, :order, [:about])
    {[links, ifs(print_about?, [about, ?\n])], conf}
  end

  @spec format(%ExDoc.ModuleNode{}, list) :: iodata
  def format(node, config) do
    docs_map = by_type(node.docs, %{def: [], defmacro: [], callback: []})
    node_data = Map.merge(Map.from_struct(node), docs_map)
    order = Dict.get(config, :order, @default_order)
    Enum.map(order, &format(&1, node_data, config))
  end

  defp by_type([], res) do
    res
  end
  defp by_type([%{doc: :false}|t], res) do
    by_type(t, res)
  end
  defp by_type([h|t], res) do
    newres = Map.update!(res, h.type, &([h|&1]))
    by_type(t, newres)
  end

  defp format(:title, %{id: id}, config)
  when is_binary(id) do
    [ "# #{id}\n\n",
      ifs(config[:link_title], [anchor(id), "\n\n"]),
      ifs(v = Dict.get(config, :version), ["version", v, "\n\n"]) ]
  end
  defp format(:about, _, config) do
    ifs(abt = Dict.get(config, :about, :false), nl_sep(abt))
  end
  defp format(:links, node, _config) do
    l = Enum.map([:typespecs | @funct], &link(funct_name(&1), node[&1]))
    [link("description", :true), l, ?\n]
  end
  defp format(:moduledoc, %{moduledoc: md}, _config) when is_binary(md) do
    [h2("description"), md, ?\n]
  end
  defp format(:typespecs, %{typespecs: ts}, _config)
  when is_list(ts) and ts != [] do
    format_typespecs(ts)
  end
  defp format(funct, node, _config) when funct in @funct do
    format_docs(funct_name(funct), node[funct])
  end
  defp format(_, _node, _config) do
    ""
  end

  defp funct_name(:def), do: "functions"
  defp funct_name(:defmacro), do: "macros"
  defp funct_name(:callback), do: "callbacks"
  defp funct_name(:typespecs), do: "types"

  defp link(_name, []) do
    ""
  end
  defp link(<<fc, rest :: binary>> = name, _) do
    title = String.upcase(<<fc>>) <> rest
    "* [#{title}](##{name})\n"
  end

  defp format_typespecs(types) do
    [ h2("types") | format_typespecs(types, []) ]
  end
  defp format_typespecs([], formatted) do
    ["<pre>", Enum.reverse(formatted), "</pre>"]
  end
  defp format_typespecs([ts|t], formatted) do
    f = [ts.spec, ?\n, nl_sep(ts.doc), ?\n]
    format_typespecs(t, [f|formatted])
  end

  defp format_docs(_, []) do
    ""
  end
  defp format_docs(name, funs) do
    [ h2(name) | format_funs(funs, []) ]
  end

  defp format_funs([], formatted) do
    Enum.reverse(formatted)
  end
  defp format_funs([d|t], formatted) do
    f = """
    ### #{d.signature} #{anchor(d.id)}
    #{nl_sep(d.doc)}
    """
    format_funs(t, [f|formatted])
  end

  defp nl_sep(s) when is_binary(s) do
    [?\n, s, ?\n]
  end
  defp nl_sep(_) do
    []
  end

  defp h2(<<fc, rest :: binary>> = str) do
    title = String.upcase(<<fc>>) <> rest
    ~s{## #{title} <a name="#{str}"></a>\n\n}
  end

  defp anchor(name), do: ~s(<a name="#{name}"></a>)
end
