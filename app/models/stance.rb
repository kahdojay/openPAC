class Stance < ActiveRecord::Base
  belongs_to :user
  belongs_to :position
  has_many :upvotes
  has_many :legislator_stances
  has_many :legislators, through: :legislator_stances
  has_many :donations

  validates_presence_of :user_id, :position_id

  after_destroy :delete_upvotes

  def info
    { position_description: Position.find(position_id).description,
    author: User.find(user_id) }
  end

  def voted(user_id)
    upvotes.find_by(user_id: user_id) ? true : false
  end

  def delete_upvotes
    Upvote.where(stance_id: id).each{|upvote| upvote.destroy}
  end

  def total_donated_amount
    Donation.where(stance_id: id).inject(0) { |acc, donation| acc += donation.amount; acc }
  end

  def self.search(words)
    case words
    when "Popular"
      Upvote.group(:stance_id).count.sort_by{ |_,v| v }.reverse.map{ |pair| Stance.find(pair[0]) }
    when "Recent"
      Stance.all.order("created_at DESC")[0..20]
    else
      words.split(' ').map do |word|
        Stance.all.select do |s|
          s.position.description.downcase.include?(word.downcase) || s.position.issue.description.downcase.include?(word.downcase)
        end
      end.flatten.uniq
    end
  end
end