require 'open-uri'
require 'json'
require 'pp'
require 'date'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :photos, class_name: 'Photo', dependent: :destroy
  has_many :guesses, class_name: 'Guess', dependent: :destroy

  scope :random_users, ->(except, num){where.not(id: except)
                                           .order('RANDOM()')
                                           .limit(num)}
  scope :score_board, ->{select([:name, 'COUNT(*) AS score' ])
                         .joins(:guesses, "")
                         .where('guesses.correct = ?', true)
                         .group(:user_id)}

  scope :least_familiar, ->{select([:name, :url, 'COUNT(*) as wrong_guesses'])
                                  .joins(:photos, 'JOIN guesses ON guesses.photo_id = photos.id')
                                  .where('guesses.correct = ?', false)
                                  .group(:id)}

  def self.sync_with_jira
    jira_host = 'http://localhost'
    users_uri = '/rest/experimental/search'
    request_query = 'cql=type=user&limit=500'
    url = "#{jira_host}#{users_uri}?#{request_query}"

    buffer = open(url, :http_basic_authentication => ['user', 'password']).read

    result = JSON.parse(buffer)['results']

    result.each do | jira_user |
      jira_user_object = jira_user['user']
      user = User.find_by(username: jira_user_object['username'])
      if user.present?
        photo_url = jira_host + jira_user_object['profilePicture']['path']
        if user.photos.none?{|photo| photo.url == photo_url}
          Photo.create!(user: user,
                        uploader: user,
                        url: photo_url)
          puts "Modified: " + user.username
        end

      else
        user = User.create!(name: jira_user_object['displayName'],
                            username: jira_user_object['username'])
        Photo.create!(user: user,
                      uploader: user,
                      url: "#{jira_host}#{jira_user_object['profilePicture']['path']}")
        puts "Added: " + user.username
      end
    end

    puts "Finished!\n\n"
  end
end
