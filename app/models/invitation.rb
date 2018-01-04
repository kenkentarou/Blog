# == Schema Information
#
# Table name: invitations
#
#  id               :bigint(8)        not null, primary key
#  uuid             :string(255)      not null
#  name             :string(255)      not null
#  crypted_password :string(255)
#  role             :integer          default("writer")
#  user_id          :bigint(8)
#  expires_at       :datetime         not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  deleted_at       :datetime
#
# Indexes
#
#  index_invitations_on_deleted_at  (deleted_at)
#  index_invitations_on_user_id     (user_id)
#  index_invitations_on_uuid        (uuid) UNIQUE
#

class Invitation < ApplicationRecord
  include UserName
  include Role

  belongs_to :user

  delegate :name, to: :user, prefix: true, allow_nil: true

  validate :valid_unique_username?

  before_create -> { self.uuid = SecureRandom.uuid }
  before_create -> { self.expires_at = 1.day.since }

  scope :validity, -> { where('expires_at > ?', Time.zone.now) }

  def valid_unique_username?
    if User.exists?(name: name)
      errors.add(:name, 'すでに登録されています')
      false
    end
      true
    else
  end

  def expired?
    expires_at <= Time.zone.now
  end
end
