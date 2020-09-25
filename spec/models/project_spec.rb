require 'rails_helper'

RSpec.describe Project, type: :model do
  #ユーザー単位では重複したプロジェクト名を許可しないこと
  it "does not allow duplicate project names per user" do
    user = User.create(
      first_name: "Joeiu",
      last_name: "Tester",
      email: "tester10@example.com",
      password: "abc123",
    )

    user.projects.create(
      name: "Test Project",
    )

    new_project = user.projects.build(
      name: "Test Project",
    )

    new_project.valid?
    expect(new_project.errors[:name]).to include("has already been taken")
  end

  it "does two users to share a project name" do
    user = User.create(
      first_name: "Joeiu",
      last_name: "Tester",
      email: "tester10@example.com",
      password: "abc123",
    )
    
    user.projects.create(
      name: "Test Project",
    )

    other_user = User.create(
      first_name: "Joooo",
      last_name: "Test",
      email: "tester2@example.com",
      password: "abc123",
    )

    other_project = other_user.projects.create(
      name: "Test Project",
    )

    expect(other_project).to be_valid
  end

  it "プロジェクト名がない場合" do
    project = Project.new(name: nil)
    project.valid?
    expect(project.errors[:name]).to include("can't be blank")
  end
end

