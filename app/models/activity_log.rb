# == Schema Information
#
# Table name: activity_logs
#
#  id            :integer          not null, primary key
#  user_id       :integer          not null
#  event         :string           not null
#  url           :string           not null
#  ip_address    :inet
#  user_agent_id :integer
#  metadata      :jsonb
#  created_at    :datetime         not null
#

class ActivityLog < ActiveRecord::Base
  belongs_to :user
  belongs_to :user_agent

  validates_presence_of :user
  validates_presence_of :event

end
