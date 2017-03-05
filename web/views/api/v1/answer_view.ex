defmodule Whale2.Api.V1.AnswerView do
    use Whale2.Web, :view

    def render("index.json", %{answers: answers}) do
        %{data: render_many(answers, __MODULE__, "answer.json")}
    end

    def render("show.json", %{answer: answer}) do
        %{data: render_one(answer, __MODULE__, "answer.json")}
    end

    def render("answer.json", %{answer: answer}) do
        %{
            id: answer.id,
            thumbnail_url: Whale2.Uploaders.AnswerThumbnailUploader.url({answer.thumbnail, answer}, :thumb),
            video_url: Whale2.Uploaders.AnswerVideoUploader.url({answer.video, answer}, :medium),
            likes: render(Whale2.Api.V1.LikeView, "index.json", likes: answer.likes)
        }
    end
end