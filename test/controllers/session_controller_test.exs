defmodule Pxblog.SessionControllerTest do

    use Pxblog.ConnCase
    alias Pxblog.TestHelper
    
    setup do
        {:ok, role} = TestHelper.create_role(%{name: "user", admin: false})
        {:ok, _user} = TestHelper.create_user(role, %{username: "test",
                                                      email: "test@test.com",
                                                      password: "test",
                                                      password_confirmation: "test"})
        {:ok, conn: build_conn()}
    end
    
    test "shows the login form" do
        conn = get build_conn, session_path(build_conn, :new)
        assert html_response(conn, 200) =~ "Login"
    end
    
    test "creates a new user session for a valid user", %{conn: conn} do
        conn = post conn, session_path(conn, :create), user: %{username: "test",
                                                               password: "test"}
        assert get_session(conn, :current_user)
        assert get_flash(conn, :info) == "Sign in succesful!"
        assert redirected_to(conn) == page_path(conn, :index)
    end
    
    test "does not create a session with bad login", %{conn: conn} do
        conn = post conn, session_path(conn, :create), user: %{username: "test",
                                                               password: "wrong"}
        refute get_session(conn, :current_user)
        assert get_flash(conn, :error) == "Invalid username/password combination!"
        assert redirected_to(conn) == page_path(conn, :index)
    end
    
    test "does not create a session if user does not exist", %{conn: conn} do
        conn = post conn, session_path(conn, :create), user: %{username: "foo",
                                                               password: "wrong"}
        assert get_flash(conn, :error) == "Invalid username/password combination!"
        assert redirected_to(conn) == page_path(conn, :index)
    end
    
end
