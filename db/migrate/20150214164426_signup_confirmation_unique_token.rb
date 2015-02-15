class SignupConfirmationUniqueToken < ActiveRecord::Migration
  def change
    add_index :signup_confirmations, [:token], unique: true
  end
end
