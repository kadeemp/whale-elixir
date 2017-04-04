defmodule Whale2.EmptyView do
    use Whale2.Web, :view

    def render("empty.json", _params) do
        %{success: true}
    end
  
end