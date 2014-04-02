class Comment < ActiveRecord::Base
  include AASM

  belongs_to :post

  validates_presence_of :body

  aasm column: 'state' do 
    state :require_approval, initial: true
    state :approved
  end
end
