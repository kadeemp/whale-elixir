defmodule Whale2.AnswerTest do
  use Whale2.ModelCase

  alias Whale2.Answer

  @valid_attrs %{"thumbnail_url,": "some content", "video_url,": "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Answer.changeset(%Answer{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Answer.changeset(%Answer{}, @invalid_attrs)
    refute changeset.valid?
  end
end
