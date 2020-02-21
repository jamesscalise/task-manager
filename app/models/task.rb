class Task < ApplicationRecord
    belongs_to :list
    belongs_to :user
    validates :content, presence: true
    validates_date :due_date, on_or_after: lambda { Date.current }

    def self.incomplete_tasks
        where(completed: false)
    end

    def self.next_ten_due
        order('due_date ASC').limit(10)
    end
end
