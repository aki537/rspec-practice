require 'rails_helper'

RSpec.describe Note, type: :model do
  #検索文字列に一致するメモを返すこと
  # it "returns notes that match the search term" do
  #   user = User.create(
  #     first_name: "Joe",
  #     last_name: "Tester",
  #     email: "tester@example.com",
  #     password: "abc123",
  #   )

  #   project = user.projects.create(
  #     name: "Test Project"
  #   )

  #   note1 = project.notes.create(
  #     message: "This is the first note",
  #     user: user,
  #   )
  #   note2 = project.notes.create(
  #     message: "This is the second note",
  #     user: user,
  #   )
  #   note3 = project.notes.create(
  #     message: "First, preheat the oven",
  #     user: user,
  #   )

  #   expect(Note.search("first")).to include(note1,note3)
  #   expect(Note.search("first")).to_not include(note2)
  # end

  # #検索結果が1件も見つからなければ空のコレクションを返すこと
  # it "returns an empty collection when no results are found" do
  #   user = User.create(
  #     first_name: "Joe",
  #     last_name: "Tester",
  #     email: "tester@example.com",
  #     password: "abc123",
  #   )

  #   project = user.projects.create(
  #     name: "Test Project"
  #   )

  #   note1 = project.notes.create(
  #     message: "This is the first note",
  #     user: user,
  #   )
  #   note2 = project.notes.create(
  #     message: "This is the second note",
  #     user: user,
  #   )
  #   note3 = project.notes.create(
  #     message: "First, preheat the oven",
  #     user: user,
  #   )

  #   expect(Note.search("message")).to be_empty
  # end
  
  #文字列に一致するメッセージを検索する(beforeバージョン)
    # before do
    #   @user = User.create(
    #     first_name: "Joewr",
    #     last_name: "Tester",
    #     email: "tester20@example.com",
    #     password: "abc123",
    #   )

    #   @project = @user.projects.create(
    #     name: "Test Project2",
    #   )
    # end
  
  #文字列に一致するメッセージを検索する(letバージョン)※この場合はインスタンス変数じゃなくなる
  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project, owner: user) }

  #ユーザー、プロジェクト、メッセージがあれば有効な状態であること
  it "is valid with a user, project, and message" do
    note = Note.new(
      message: "This is a sample first note",
      user: user,
      project: project,
    )
    expect(note).to be_valid
  end

  #メッセージがなければ無効
  it "is invalid without a message" do
    note = Note.new(message: nil)
    note.valid?
    expect(note.errors[:message]).to include("can't be blank")
  end

  describe "search message for a term" do
    #beforeの場合
      # before do
      #   @note1 = @project.notes.create(
      #     message: "This is the first note",
      #     user: @user,
      #   )
      #   @note2 = @project.notes.create(
      #     message: "This is the second note",
      #     user: @user,
      #   )
      #   @note3 = @project.notes.create(
      #     message: "First, preheat the oven",
      #     user: @user,
      #   )
      # end
    
    #letの場合
    let!(:note1) {
      FactoryBot.create(:note,
        project: project,
        user: user,
        message: "This is the first note.",
      )
    }

    let!(:note2) {
      FactoryBot.create(:note,
        project: project,
        user: user,
        message: "This is the second note.",
      )
    }
    let!(:note3) {
      FactoryBot.create(:note,
        project: project,
        user: user,
        message: "First, preheat the oven.",
      )
    }

    #一致するデータが見つかる時
    context "when a match is found" do
      #検索文字列に一致するメモを返すこと
      it "returns notes that match the search term" do
        expect(Note.search("first")).to include(note1,note3)
        expect(Note.search("first")).to_not include(note2)
      end
    end

    #一致するデータが1件も見つからない時
    context "when no match is found" do
      #検索する文字列に一致するメモを返すこと
      it "returns an empty collection when no results are found" do
        expect(Note.search("message")).to be_empty
        expect(Note.count).to eq 6
      end
    end
  end
end
