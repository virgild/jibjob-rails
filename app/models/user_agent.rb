# == Schema Information
#
# Table name: user_agents
#
#  id           :integer          not null, primary key
#  agent_id     :string           not null
#  agent_string :string           not null
#
# Indexes
#
#  index_user_agents_on_agent_id  (agent_id) UNIQUE
#

class UserAgent < ActiveRecord::Base
  validates_presence_of :agent_id
  validates_presence_of :agent_string

  before_validation :generate_agent_id, on: :create

  # Creates a UserAgent record based on the agent string.
  def self.do_record(agent_string)
    checksum = agent_string_checksum(agent_string)
    UserAgent.create_with(agent_string: agent_string).find_or_create_by(agent_id: checksum)
  end

  def self.agent_string_checksum(agent_string)
    Zlib.crc32(agent_string).to_s
  end

  private

  def generate_agent_id
    self.agent_id = UserAgent.agent_string_checksum(self.agent_string)
  end
end
