require 'rails_helper'

RSpec.describe Project, type: :model do
  #ユーザー単位では重複したプロジェクト名を許可しないこと
  it "does not allow duplicate project names per user" do
    user = FactoryBot.create(:user)
    # user = User.create(
    #   first_name: "Joeiu",
    #   last_name: "Tester",
    #   email: "tester10@example.com",
    #   password: "abc123",
    # )

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
    user = FactoryBot.create(:user)
    # user = User.create(
    #   first_name: "Joeiu",
    #   last_name: "Tester",
    #   email: "tester10@example.com",
    #   password: "abc123",
    # )
    
    user.projects.create(
      name: "Test Project",
    )

    other_user = FactoryBot.create(:user)
    # other_user = User.create(
    #   first_name: "Joooo",
    #   last_name: "Test",
    #   email: "tester2@example.com",
    #   password: "abc123",
    # )

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

  #たくさんのメモがついていること
  it "can have many notes" do
    project = FactoryBot.create(:project, :with_notes)
    expect(project.notes.length).to eq 5
  end

  #遅延ステータス
  describe "late status" do
    #締切日が過ぎていれば遅延していること
    it "is late when the due date is past today" do
      project = FactoryBot.create(:project, :due_yesterday)
      # project = FactoryBot.create(:project_due_yesterday)
      expect(project).to be_late
    end

    #締切日が今日ならスケジュールどおりであること
    it "is on time when the due date is today" do
      project = FactoryBot.create(:project, :due_today)
      # project = FactoryBot.create(:project_due_today)
      expect(project).to_not be_late
    end
      
    #締切日が未来ならスケジュールどおりであること
    it "is on time when the due date is the future" do
      project = FactoryBot.create(:project, :due_tomorrow)
      # project = FactoryBot.create(:project_due_tomorrow)
      expect(project).to_not be_late
    end
  end
end

