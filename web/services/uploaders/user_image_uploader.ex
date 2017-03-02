defmodule Whale2.Uploaders.UserImage do
    use Arc.Definition
    use Arc.Ecto.Definition

    @acl :public_read
    @versions [:original, :medium, :thumb]

    @heights %{
      medium: 500,
      thumb: 200
    }

    def validate({file, _}) do
      ~w(.jpg .jpeg .gif .png) |> Enum.member?(Path.extname(file.file_name))
    end

    def transform(:thumb, _file) do
      {:convert, "-thumbnail x#{@heights[:thumb]} -gravity center -format jpg"}
    end

    def transform(:medium, _file) do
      {:convert, "-strip -resize x#{@heights[:medium]} -gravity center -format png"}
    end

    def storage_dir(version, {file, scope}) do
      "uploads/users/avatars/#{scope.id}"
    end

    def default_url(:thumb) do
        "https://placehold.it/100x100"
    end

    def s3_object_headers(_version, {file, _scope}) do
        # For "image.png", would produce: "image/png"
        [content_type: Plug.MIME.path(file.file_name)]
    end

    def __storage, do: Arc.Storage.S3
end