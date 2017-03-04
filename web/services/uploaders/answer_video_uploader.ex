defmodule Whale2.Uploaders.AnswerVideoUploader do
    use Arc.Definition
    use Arc.Ecto.Definition

    @acl :public_read
    @versions [:original, :medium, :thumb]

end