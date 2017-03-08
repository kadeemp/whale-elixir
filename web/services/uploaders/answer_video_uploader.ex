defmodule Whale2.Uploaders.AnswerVideoUploader do
    use Arc.Definition
    use Arc.Ecto.Definition

    @acl :public_read
    @versions [:original, :medium]
    @extension_whitelist ~w(.mpeg4 .mov .m4v)

    @video_size %{
        medium: "640:-1"
    }

    def validate({file, _}) do
      @extension_whitelist |> Enum.member?(Path.extname(file.file_name))
    end

    def transform(:original, _file) do
      {:ffmpeg, fn(input, output) -> "-i #{input} -f mov #{output}" end, :mov}
    end

    def transform(:medium, _file) do
      {:ffmpeg, fn(input, output) -> "-i #{input} -f mov -vcodec libx264 -vf scale=#{@video_size[:medium]} -crf 24 -b:v 500k -acodec copy #{output}" end, :mov}
    end

    def storage_dir(_version, {_, scope}) do
        "users/answers/question_#{scope.question_id}/videos"
    end

    def filename(version, {file, _}) do
     "#{Path.rootname(file.file_name)}_#{version}"
    end

    def __storage, do: Arc.Storage.S3

end