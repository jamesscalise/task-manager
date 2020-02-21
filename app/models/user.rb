class User < ApplicationRecord
    has_secure_password
    has_many :tasks
    has_many :lists, through: :tasks
    validates :name, presence: true
    validates :password, length: { in: 6..20 }

    
end
