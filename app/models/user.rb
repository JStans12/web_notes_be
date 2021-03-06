class User < ApplicationRecord
  after_create :give_secret

  has_secure_password

  enum role: ["user", "admin"]
  enum status: ["pending", "confirmed"]

  validates_presence_of   :name, :email
  validates_uniqueness_of :name, :email
  validates :name, format: { with: /\A[a-zA-Z0-9]+\Z/ }, length: { maximum: 64 }

  has_many :comments, dependent: :destroy
  has_many :pages, through: :comments
  has_many :ups, dependent: :destroy

  def comment(body, page, parent = nil)
    comment = comments.create(body: body, page_id: page.id)
    comment.update(parent_id: parent.id) if parent
    upvote(comment)
    comment
  end

  def upvote(comment)
    vote = ups.find_or_create_by(comment_id: comment.id)
    vote.update(value: 1)
    vote
  end

  def downvote(comment)
    vote = ups.find_or_create_by(comment_id: comment.id)
    vote.update(value: -1)
    vote
  end

  def novote(comment)
    vote = ups.find_or_create_by(comment_id: comment.id)
    vote.update(value: 0)
    vote
  end

  def score
    comments
    .joins(:ups)
    .where.not('ups.user_id = comments.user_id')
    .sum('ups.value')
  end

  def give_secret
    update(secret: generate_token)
  end

  def confirmed!
    update(status: 1)
    update(token: generate_token)
    secret.clear
    save
  end

  private

  def generate_token
    loop do
      token = SecureRandom.hex(25)
      break token unless User.where(token: token).exists?
    end
  end
end
