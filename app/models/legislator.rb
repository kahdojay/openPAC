class Legislator < ActiveRecord::Base
  has_many :legislator_stances
  has_many :stances, through: :legislator_stances
  has_many :bill_votes
  has_many :bills, through: :bill_votes
  has_many :terms
  has_one :alias
  has_many :donations
  has_many :legislator_issues
  has_many :issues, through: :legislator_issues

  validates_uniqueness_of :bioguide_id
  validates_presence_of :bioguide_id, :first_name, :last_name

  def name
    "#{first_name} #{last_name}"
  end

  def current_state
    terms.first.state
  end

  def current_chamber
    terms.last.chamber.capitalize
  end

  def offical_prefix
    (terms.last.chamber == "house") ? "Rep." : "Sen."
  end

  def get_issue_score(issue)
    legislator_issues.for_issue(issue).first.issue_score if !legislator_issues.for_issue(issue).empty?
  end

  def self.filter_legislators_by_vote_count(issue_id)
    array = []
    BillVote.where(issue_id: issue_id).group(:legislator_id).count.sort_by {|k,v| v}.reverse.slice(0,300).to_h.each do |k,v|
      array << Legislator.find(k)
    end
    array.sample(80)
  end
end

