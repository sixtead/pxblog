alias Pxblog.Repo
alias Pxblog.Role
alias Pxblog.User

role = %Role{}
  |> Role.changeset(%{name: "Admin Role", admin: true})
  |> Repo.insert!
admin = %User{}
  |> User.changeset(%{username: "admin",
                      email: "admin@test.com",
                      password: "admin",
                      password_confirmation: "admin",
                      role_id: role.id})
  |> Repo.insert!