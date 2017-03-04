defmodule Whale2.Uploaders.UserImage do
    use Arc.Definition
    use Arc.Ecto.Definition
    require IEx

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

    def storage_dir(version, {_, scope}) do
      "users/avatars/#{scope.id}"
    end

    def filename(version, _) do
      version
    end

    def default_url(:thumb) do
        "https://placehold.it/100x100"
    end

    def s3_object_headers(_version, {file, _scope}) do
        [content_type: Plug.MIME.path(file.file_name)]
    end

    def __storage, do: Arc.Storage.S3
end