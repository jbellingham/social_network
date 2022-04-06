defmodule SocialNetworkWeb.PostLiveTest do
  use SocialNetworkWeb.ConnCase

  import Phoenix.LiveViewTest
  import SocialNetwork.Repositories.PostsFixtures
  import SocialNetwork.Repositories.UsersFixtures

  @create_attrs %{body: "some body"}
  @update_attrs %{body: "some updated body"}
  @invalid_attrs %{body: nil}

  defp create_post(_) do
    post = post_fixture()
    %{post: post}
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end

  describe "Index - unauthenticated" do
    setup [:create_post]

    test "lists all posts", %{conn: conn, post: post} do
      {:ok, _index_live, html} = live(conn, Routes.post_index_path(conn, :index))

      assert html =~ "Listing Posts"
      assert html =~ post.body
    end

    test "does not display edit button", %{conn: conn} do
      {:ok, _show_live, html} = live(conn, Routes.post_index_path(conn, :index))
      refute html =~ "Edit"
    end

    test "does not display delete button", %{conn: conn} do
      {:ok, _show_live, html} = live(conn, Routes.post_index_path(conn, :index))
      refute html =~ "Delete"
    end
  end

  describe "Index - authenticated" do
    setup [:create_post, :create_user]
    test "saves post succeeds when authenticated", %{conn: conn, user: user} do
      conn = Plug.Test.init_test_session(conn, user_id: user.id)

      {:ok, index_live, _html} = live(conn, Routes.post_index_path(conn, :index))

      assert index_live |> element("a", "New Post") |> render_click() =~
               "New Post"

      assert_patch(index_live, Routes.post_index_path(conn, :new))

      assert index_live
             |> form("#post-form", post: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#post-form", post: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.post_index_path(conn, :index))

      assert html =~ "Post created successfully"
      assert html =~ "some body"
    end

    test "updates post in listing", %{conn: conn, post: post, user: user} do
      conn = Plug.Test.init_test_session(conn, user_id: user.id)

      {:ok, index_live, _html} = live(conn, Routes.post_index_path(conn, :index))

      assert index_live |> element("#post-#{post.id} a", "Edit") |> render_click() =~
               "Edit Post"

      assert_patch(index_live, Routes.post_index_path(conn, :edit, post))

      {:ok, _, html} =
        index_live
        |> form("#post-form", post: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.post_index_path(conn, :index))

      assert html =~ "Post updated successfully"
      assert html =~ "some updated body"
    end

    test "update with invalid form data shows validation error", %{conn: conn, post: post, user: user} do
      conn = Plug.Test.init_test_session(conn, user_id: user.id)

      {:ok, index_live, _html} = live(conn, Routes.post_index_path(conn, :index))

      assert index_live |> element("#post-#{post.id} a", "Edit") |> render_click() =~
               "Edit Post"

      assert_patch(index_live, Routes.post_index_path(conn, :edit, post))

      assert index_live
             |> form("#post-form", post: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"
    end

    test "deletes post in listing", %{conn: conn, post: post, user: user} do
      conn = Plug.Test.init_test_session(conn, user_id: user.id)

      {:ok, index_live, _html} = live(conn, Routes.post_index_path(conn, :index))

      assert index_live |> element("#post-#{post.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#post-#{post.id}")
    end

  end

  describe "Show - unauthenticated" do
    setup [:create_post]

    test "displays post", %{conn: conn, post: post} do
      {:ok, _show_live, html} = live(conn, Routes.post_show_path(conn, :show, post))

      assert html =~ "Show Post"
      assert html =~ post.body
    end

    test "does not display edit button", %{conn: conn, post: post} do
      {:ok, _show_live, html} = live(conn, Routes.post_show_path(conn, :show, post))
      refute html =~ "Edit"
    end
  end

  describe "Show - authenticated" do
    setup [:create_post, :create_user]

    test "updates post within modal", %{conn: conn, post: post, user: user} do
      conn = Plug.Test.init_test_session(conn, user_id: user.id)

      {:ok, show_live, _html} = live(conn, Routes.post_show_path(conn, :show, post))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Post"

      assert_patch(show_live, Routes.post_show_path(conn, :edit, post))

      {:ok, _, html} =
        show_live
        |> form("#post-form", post: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.post_show_path(conn, :show, post))

      assert html =~ "Post updated successfully"
      assert html =~ "some updated body"
    end

    test "update with invalid form data shows validation error", %{conn: conn, post: post, user: user} do
      conn = Plug.Test.init_test_session(conn, user_id: user.id)

      {:ok, show_live, _html} = live(conn, Routes.post_show_path(conn, :show, post))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Post"

      assert_patch(show_live, Routes.post_show_path(conn, :edit, post))

      assert show_live
            |> form("#post-form", post: @invalid_attrs)
            |> render_change() =~ "can&#39;t be blank"

    end
  end
end
