defmodule Whale2.Uploaders.AnswerThumbnailUploader do
    use Arc.Definition
    use Arc.Ecto.Definition

    @acl :public_read
    @versions [:original, :medium, :thumb]
    @extension_whitelist ~w(.jpg .jpeg .gif .png)

    @heights %{
        medium: 500,
        thumb: 200
    }

    def validate({file, _}) do
        @extension_whitelist |> Enum.member?(Path.extname(file.file_name))
    end

    def transform(:thumb, _file) do
      {:convert, "-thumbnail x#{@heights[:thumb]} -gravity center -format jpg"}
    end

    def transform(:medium, _file) do
      {:convert, "-strip -resize x#{@heights[:medium]} -gravity center -format png"}
    end

    def storage_dir(_version, {_, scope}) do
    "users/answers/question_#{scope.question_id}/thumbnails"
    end

    def default_url(:thumb) do
        "https://placehold.it/100x100"
    end

    def s3_object_headers(_version, {file, _scope}) do
        [content_type: Plug.MIME.path(file.file_name)]
    end

    def filename(version, {file, _}) do
        "#{Path.rootname(file.file_name)}_#{version}"
    end

    def __storage, do: Arc.Storage.S3
end