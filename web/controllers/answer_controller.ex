defmodule Whale2.Api.V1.AnswerController do
  use Whale2.Web, :controller
  alias Whale2.Api.V1.AnswerView
  alias Whale2.{Answer, Like}
  require IEx

  def index(conn, params) do
    answers =
      params
      |> to_pagination_attributes
      |> answer_query
      |> Repo.all

    render(conn, "index.json", answers: answers)
  end

  def create(conn, params) do
    changeset = Answer.changeset(%Answer{}, params)

    with {:ok, answer} <- Repo.insert(changeset) do
      answer = answer |> Repo.preload(:likes)

      conn
      |> put_status(:created)
      |> render("show.json", answer: answer)
    else
      {:error, _changeset} -> send_resp(conn, 422, "")
    end
  end

  defp answer_query(%{per_page: per_page, page: page}) do
    offset = page * per_page

    from a in Answer,
      preload: :likes,
      limit: ^per_page,
      offset: ^offset
  end

  @default_page 0
  @default_per_page 20

  defp to_pagination_attributes(params) do
    per_page =
      Map.get(params, "per_page")
      |> sanitize_pagination_value(@default_per_page)

    page =
      Map.get(params, "page")
      |> sanitize_pagination_value(@default_page)

    %{per_page: per_page, page: page}
  end

  defp sanitize_pagination_value(nil, default), do: default
  defp sanitize_pagination_value(value, _default), do: String.to_integer(value)

end
