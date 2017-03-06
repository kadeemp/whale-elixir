defmodule Whale2.Paginator do
    alias Whale2.Paginator
    import Ecto.Query
    alias Whale2.Repo

    defstruct [:entries, :page, :per_page, :total_pages]

    @default_page 0
    @default_per_page 20

    def new(query, params) do

        per_page =
            Map.get(params, "per_page")
            |> sanitize_pagination_value(@default_per_page)

        page =
            Map.get(params, "page")
            |> sanitize_pagination_value(@default_page)

        all_entries = entries(query, page, per_page)
        total_pages = total_pages(query, per_page)

        %Paginator{
            entries: all_entries,
            page: page,
            per_page: per_page,
            total_pages: total_pages
        }
    end

    defp entries(query, page, per_page) do
        offset = per_page * (page)

        query
        |> limit([_], ^per_page)
        |> offset([_], ^offset)
        |> Repo.all

    end

    defp total_pages(query, per_page) do
        count = query
            |> exclude(:order_by)
            |> exclude(:preload)
            |> exclude(:select)
            |> select([e], count(e.id))
            |> Repo.one

        ceiling(count / per_page)
    end

    defp sanitize_pagination_value(nil, default), do: default
    defp sanitize_pagination_value(value, _default), do: String.to_integer(value)

    defp ceiling(float) do
      t = trunc(float)

      case float - t do
        neg when neg < 0 ->
          t
        pos when pos > 0 ->
          t + 1
        _ -> t
      end
    end
end