require 'rails_helper'

describe Api::V1::CommentsController do
  context "create" do
    it "returns success message and creates comment" do
      reddit = Page.create(url: "https://www.reddit.com/")
      user = create(:user)
      user.confirmed!

      post "/api/v1/users/#{user.id}/comments", params: { parent_id: 0, body: "WOO", token: user.token }, headers: {'HTTP_URL': reddit.url}
      message = response.body

      expect(message).to eq("{\"success\":\"comment created\"}")
      expect(Comment.count).to eq(1)
      expect(Comment.first.body).to eq("WOO")
    end
  end

  context "create sad path invalid user" do
    it "returns success message and creates comment" do
      reddit = Page.create(url: "https://www.reddit.com/")
      user = create(:user)
      user.confirmed!

      post "/api/v1/users/#{user.id}/comments", params: { parent_id: 0, body: "WOO", token: 555 }, headers: {'HTTP_URL': reddit.url}
      message = response.body

      expect(message).to eq("{\"failure\":\"invalid credentials\"}")
      expect(Comment.count).to eq(0)
    end
  end

  context "update" do
    it "returns a success message and updates a comment" do
      reddit = Page.create(url: "https://www.reddit.com/")
      user = create(:user)
      user.confirmed!
      comment = user.comment("WOO", reddit)

      put "/api/v1/users/#{user.id}/comments/#{comment.id}", params: { body: "BOO", token: user.token }

      message = response.body

      expect(message).to eq("{\"success\":\"comment updated\"}")
      expect(Comment.count).to eq(1)
      expect(Comment.first.body).to eq("BOO")
    end
  end

  context "update sad path invalid user" do
    it "returns a success message and updates a comment" do
      reddit = Page.create(url: "https://www.reddit.com/")
      user = create(:user)
      user.confirmed!
      comment = user.comment("WOO", reddit)

      put "/api/v1/users/#{user.id}/comments/#{comment.id}", params: { body: "BOO", token: 555 }

      message = response.body

      expect(message).to eq("{\"failure\":\"invalid credentials\"}")
      expect(Comment.count).to eq(1)
      expect(Comment.first.body).to eq("WOO")
    end
  end

  context "destroy" do
    it "returns a success message and deletes a comment" do
      reddit = Page.create(url: "https://www.reddit.com/")
      user = create(:user)
      user.confirmed!
      comment = user.comment("WOO", reddit)

      delete "/api/v1/users/#{user.id}/comments/#{comment.id}", params: { body: "", token: user.token }

      message = response.body

      expect(message).to eq("{\"success\":\"comment destroyed\"}")
      expect(Comment.count).to eq(0)
    end
  end

  context "destroy sad path invalid user" do
    it "returns a success message and deletes a comment" do
      reddit = Page.create(url: "https://www.reddit.com/")
      user = create(:user)
      user.confirmed!
      comment = user.comment("WOO", reddit)

      delete "/api/v1/users/#{user.id}/comments/#{comment.id}", params: { body: "", token: 555 }

      message = response.body

      expect(message).to eq("{\"failure\":\"invalid credentials\"}")
      expect(Comment.count).to eq(1)
    end
  end
end
