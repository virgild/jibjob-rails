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

require 'rails_helper'

RSpec.describe UserAgent, type: :model do
  context "::do_record" do
    it "generates the agent_id" do
      user_agent = UserAgent.do_record("Test Browser 1.0")
      expect(user_agent.agent_id).to_not be_blank
    end

    it "returns a previously saved record" do
      user_agent1 = UserAgent.do_record("Test Browser 1.0")
      user_agent2 = UserAgent.do_record("Test Browser 1.0")
      expect(user_agent2.id). to eq user_agent1.id
    end
  end
end
