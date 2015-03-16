shared_examples "oauth signup" do
  before do
    user.valid?
  end

  it "generates username from auth hash" do
    expect(user.username).to_not be_blank
  end

  it "sets a random password" do
    expect(user.password).to_not be_blank
  end
end