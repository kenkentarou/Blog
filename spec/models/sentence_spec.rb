# == Schema Information
#
# Table name: sentences
#
#  id         :bigint(8)        not null, primary key
#  headline   :string(255)
#  body       :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Sentence, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end