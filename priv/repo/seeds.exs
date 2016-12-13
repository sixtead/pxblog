alias Pxblog.Repo
alias Pxblog.Role
alias Pxblog.User

import Ecto.Query, only: [from: 2]

find_or_create_role = fn role_name, admin ->
  case Repo.all(from r in Role, where: r.name == ^role_name and r.admin == ^admin) do
    [] ->
      %Role{}
      |> Role.changeset(%{name: role_name, admin: admin})
      |> Repo.insert!
    _ ->
      IO.puts "Role: #{role_name} already exists, skipping"
  end
end

find_or_create_user = fn username, email, role ->
  case Repo.all(from u in User, where: u.username == ^username and u.email == ^email) do
    [] ->
      %User{}
      |> User.changeset(%{username: username,
                          email: email,
                          password: "qwerty",
                          password_confirmation: "qwerty",
                          role_id: role.id
      })
      |> Repo.insert!
    _ ->
      IO.puts "User: #{username} already exists, skipping"
  end
end

user_role = find_or_create_role.("User Role", false)
admin_role = find_or_create_role.("Admin Role", true)

user = find_or_create_user.("user", "user@test.com", user_role)
admin = find_or_create_user.("admin", "admin@test.com", admin_role)