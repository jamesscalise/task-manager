class List < ApplicationRecord
    has_many :tasks
    has_many :users, through: :tasks
    validates :name, presence: true
end
