class Photo < ActiveRecord::Base
  belongs_to :user, class_name: 'User'
  belongs_to :uploader, class_name: 'User'
  has_many :guesses

  scope :for_user, ->(user_id){ where(user_id: user_id) }
  scope :random, ->(user_id) { where.not(id: [Photo.where(user_id: user_id),
                                              Guess.correct_answers(user_id).pluck('photo_id')
                                              ].flatten
                                          )
                               .where.not('url LIKE ?', '%default.png')
                               .order('RANDOM()')
                               .limit(1)
                               .first }
end
