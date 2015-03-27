require 'rails_helper'

RSpec.describe RecordActivityLogJob, type: :job do
  fixtures :all

  context "after running" do
    let(:user) { users(:appleseed) }
    let(:user_agent) { user_agents(:test_browser) }

    it "creates an activity_log" do
      activity_log = RecordActivityLogJob.perform_now(user, 'test.event', '/test_url', '127.0.0.1', 'Test Browser 1.0', Time.now.to_i)
      expect(activity_log).to_not be_nil
    end
  end
end