class Guess < ActiveRecord::Base
  belongs_to :user, class_name: 'User'
  belongs_to :photo, class_name: 'Photo'

  scope :correct_answers, ->(user_id){ where('user_id = ? AND correct = ?', user_id, true) }

  def self.generate(user_id)
    photo = Photo.random(user_id)
    return if photo.nil?

    users = User.random_users([user_id, photo.user.id], 3)
                .select(:id, :name)
                .push(photo.user.slice(:id, :name))
                .shuffle

    return { photo_id: photo.id, photo_url: photo.url, users: users }

  end
end
