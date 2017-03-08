defmodule Whale2.Api.V1.AnswerView do
    use Whale2.Web, :view

    def render("index.json", %{answers: answers}) do
        %{  page: answers.page,
            per_page: answers.per_page,
            total_pages: answers.total_pages,
            data: render_many(answers.entries, __MODULE__, "answer.json")
        }
    end

    def render("show.json", %{answer: answer}) do
        %{data: render_one(answer, __MODULE__, "answer.json")}
    end

    def render("answer.json", %{answer: answer}) do
        %{
            id: answer.id,
            thumbnail_url: Whale2.Uploaders.AnswerThumbnailUploader.url({answer.thumbnail, answer}, :medium),
            video_url: Whale2.Uploaders.AnswerVideoUploader.url({answer.video, answer}, :medium),
            question: render(Whale2.Api.V1.QuestionView, "show.json", question: answer.question)
        }
    end
end
