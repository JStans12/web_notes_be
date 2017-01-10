require 'rails_helper'

describe Api::V1::PagesController do
  context '/me' do
    it 'returns me data' do
      reddit = Page.create(url: "https://www.reddit.com/")
      user, user2 = create_list(:user, 2)
      user.confirmed!
      user2.confirmed!

      comment = user.comment("Hey Reddit!", reddit)
      comment2 = user2.comment("Oh, hey!", reddit, comment)
      user.upvote(comment2)

      get '/api/v1/me', params: { token: user2.token }
      me = JSON.parse(response.body, symbolize_names: true)

      expect(me[:name]).to eq(user2.name)
      expect(me[:email]).to eq(user2.email)
      expect(me[:score]).to eq(1)
    end
  end
end
