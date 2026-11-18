class AddAdminReplyToReviews < ActiveRecord::Migration[7.1]
  def change
    add_column :reviews, :admin_reply, :text
    add_column :reviews, :admin_replied_at, :datetime
  end
end
