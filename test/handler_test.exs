defmodule HandlerTest do
  use ExUnit.Case

  import Servy.Handler, only: [handle: 1]

  describe "handle/1" do
    test "GET /wildthings" do
      request = """
      GET /wildthings HTTP/1.1\r
      Host: example.com\r
      User-Agent: ExampleBrowser/1.0\r
      Accept: */*\r
      \r
      """

      response = handle(request)

      assert response == """
             HTTP/1.1 200 OK\r
             Content-Type: text/html\r
             Content-Length: 20\r
             \r
             Bears, Lions, Tigers
             """
    end

    test "GET /bears" do
      request = """
      GET /bears HTTP/1.1\r
      Host: example.com\r
      User-Agent: ExampleBrowser/1.0\r
      Accept: */*\r
      \r
      """

      response = handle(request)

      expected_response = """
      HTTP/1.1 200 OK\r
      Content-Type: text/html\r
      Content-Length: 366\r
      \r
      <h1>All the Bears!</h1>

      <ul>
        <li>Brutus - Grizzly</li>
        <li>Iceman - Polar</li>
        <li>Kenai - Grizzly</li>
        <li>Paddington - Brown</li>
        <li>Roscoe - Panda</li>
        <li>Rosie - Black</li>
        <li>Scarface - Grizzly</li>
        <li>Smokey - Black</li>
        <li>Snow - Polar</li>
        <li>Teddy - Brown</li>
      </ul>
      """

      assert remove_whitespace(response) == remove_whitespace(expected_response)
    end

    test "GET /bigfoot" do
      request = """
      GET /bigfoot HTTP/1.1\r
      Host: example.com\r
      User-Agent: ExampleBrowser/1.0\r
      Accept: */*\r
      \r
      """

      response = handle(request)

      assert response == """
             HTTP/1.1 404 Not Found\r
             Content-Type: text/html\r
             Content-Length: 17\r
             \r
             No /bigfoot here!
             """
    end

    test "GET /bears/1" do
      request = """
      GET /bears/1 HTTP/1.1\r
      Host: example.com\r
      User-Agent: ExampleBrowser/1.0\r
      Accept: */*\r
      \r
      """

      response = handle(request)

      expected_response = """
      HTTP/1.1 200 OK\r
      Content-Type: text/html\r
      Content-Length: 72\r
      \r
      <h1>Show Bear</h1>
      <p>
      Is Teddy hibernating? <strong>true</strong>
      </p>
      """

      assert remove_whitespace(response) == remove_whitespace(expected_response)
    end

    test "GET /wildlife" do
      request = """
      GET /wildlife HTTP/1.1\r
      Host: example.com\r
      User-Agent: ExampleBrowser/1.0\r
      Accept: */*\r
      \r
      """

      response = handle(request)

      assert response == """
             HTTP/1.1 200 OK\r
             Content-Type: text/html\r
             Content-Length: 20\r
             \r
             Bears, Lions, Tigers
             """
    end

    test "GET /about" do
      request = """
      GET /about HTTP/1.1\r
      Host: example.com\r
      User-Agent: ExampleBrowser/1.0\r
      Accept: */*\r
      \r
      """

      response = handle(request)

      expected_response = """
      HTTP/1.1 200 OK\r
      Content-Type: text/html\r
      Content-Length: 334\r
      \r
      <h1>Clark's Wildthings Refuge</h1>

      <blockquote>
      When we contemplate the whole globe as one great dewdrop,
      striped and dotted with the continents and islands, flying through
      space with other stars all singing and shining together as one,
      the whole universe appears as an infinite storm of beauty.
      -- John Muir
      </blockquote>
      """

      assert remove_whitespace(response) == remove_whitespace(expected_response)
    end

    test "POST /bears" do
      request = """
      POST /bears HTTP/1.1\r
      Host: example.com\r
      User-Agent: ExampleBrowser/1.0\r
      Accept: */*\r
      Content-Type: application/x-www-form-urlencoded\r
      Content-Length: 21\r
      \r
      name=Baloo&type=Brown
      """

      response = handle(request)

      assert response == """
             HTTP/1.1 201 Created\r
             Content-Type: text/html\r
             Content-Length: 33\r
             \r
             Created a Brown bear named Baloo!
             """
    end

    test "GET /api/bears" do
      request = """
      GET /api/bears HTTP/1.1\r
      Host: example.com\r
      User-Agent: ExampleBrowser/1.0\r
      Accept: */*\r
      \r
      """

      response = handle(request)

      expected_response = """
      HTTP/1.1 200 OK\r
      Content-Type: application/json\r
      Content-Length: 605\r
      \r
      [{"hibernating":true,"id":1,"name":"Teddy","type":"Brown"},
       {"hibernating":false,"id":2,"name":"Smokey","type":"Black"},
       {"hibernating":false,"id":3,"name":"Paddington","type":"Brown"},
       {"hibernating":true,"id":4,"name":"Scarface","type":"Grizzly"},
       {"hibernating":false,"id":5,"name":"Snow","type":"Polar"},
       {"hibernating":false,"id":6,"name":"Brutus","type":"Grizzly"},
       {"hibernating":true,"id":7,"name":"Rosie","type":"Black"},
       {"hibernating":false,"id":8,"name":"Roscoe","type":"Panda"},
       {"hibernating":true,"id":9,"name":"Iceman","type":"Polar"},
       {"hibernating":false,"id":10,"name":"Kenai","type":"Grizzly"}]
      """

      assert remove_whitespace(response) == remove_whitespace(expected_response)
    end
  end

  defp remove_whitespace(text) do
    String.replace(text, ~r{\s}, "")
  end
end
