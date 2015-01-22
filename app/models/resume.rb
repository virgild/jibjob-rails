# == Schema Information
#
# Table name: resumes
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  name       :string           not null
#  slug       :string           not null
#  content    :text             not null
#  guid       :string           not null
#  status     :integer          default("0"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Resume < ActiveRecord::Base
  belongs_to :user
end