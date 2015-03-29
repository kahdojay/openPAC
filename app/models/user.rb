class User < ActiveRecord::Base
  email_format = /\b[A-Z0-9._%-]+@(?:[A-Z0-9-]+\.)+[A-Z]{2,4}\b/i
  has_secure_password

  has_many :votes
  has_many :bills, through: :votes

  validates_uniqueness_of :username

  def rescore
    if bills.empty?
      fiscal_vote_score = 0
      social_vote_score = 0
    else
      fiscal_vote_score = bills.map {|b| b.fiscal_mean}.inject(:+)
      social_vote_score = bills.map {|b| b.social_mean}.inject(:+)
    end

    fiscal_rescore = (fiscal_initial + fiscal_vote_score) / (1 + bills.count)
    social_rescore = (social_initial + social_vote_score) / (1 + bills.count)

    update(fiscal_mean: fiscal_rescore)
    update(social_mean: social_rescore)
  end

  # TODO: method to calculate fiscal/social variance?
end
