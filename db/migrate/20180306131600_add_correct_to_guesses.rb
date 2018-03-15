class AddCorrectToGuesses < ActiveRecord::Migration
  def change
    add_column :guesses, :correct, :boolean
  end
end
