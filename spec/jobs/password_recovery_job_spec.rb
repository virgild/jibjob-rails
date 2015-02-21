require 'rails_helper'

RSpec.describe PasswordRecoveryJob, type: :job do
  fixtures :all

  context "invalid identifier" do
    it "should not send an email" do
      PasswordRecoveryJob.perform_now("non_existent_username")
      assert_no_enqueued_jobs
    end
  end

  context "valid identifier" do
    let(:user) { users(:appleseed) }

    context "valid username" do
      it "sends an email" do
        PasswordRecoveryJob.perform_now(user.username)
        assert_enqueued_jobs(1)
      end

      it "does it" do
        assert_enqueued_with() do
          PasswordRecoveryJob.perform_now(user.username)
        end
      end
    end

    context "valid email" do
      it "sends an email" do
        PasswordRecoveryJob.perform_now(user.email)
        assert_enqueued_jobs(1)
      end
    end
  end
end
