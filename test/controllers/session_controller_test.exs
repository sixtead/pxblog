defmodule Pxblog.SessionControllerTest do
  use Pxblog.ConnCase
  
  import Pxblog.Factory
  
  #alias Pxblog.TestHelper
    
  setup do
    role = insert(:role)
    user = insert(:user, role: role)
    {:ok, conn: build_conn(), user: user}
  end
    
  test "shows the login form" do
      conn = get build_conn(), session_path(build_conn(), :new)
      assert html_response(conn, 200) =~ "Login"
  end
  
  test "creates a new user session for a valid user", %{conn: conn, user: user} do
      conn = post conn, session_path(conn, :create), user: %{username: user.username,
                                                             password: user.password}
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
