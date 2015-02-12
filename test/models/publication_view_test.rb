# == Schema Information
#
# Table name: publication_views
#
#  id         :integer          not null, primary key
#  resume_id  :integer          not null
#  ip_addr    :inet             not null
#  url        :string           not null
#  referrer   :string
#  user_agent :string
#  created_at :datetime         not null
#
# Indexes
#
#  index_publication_views_on_resume_id  (resume_id)
#

require 'test_helper'

class PublicationViewTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
