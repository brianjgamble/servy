defmodule Servy.Api.BearController do
  def index(conv) do
    json =
      Servy.Wildthings.list_bears()
      |> Jason.encode!()

    %{conv | status: 200, resp_content_type: "application/json", resp_body: json}
  end
end
