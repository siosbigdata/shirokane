describe "routing to posts" do

  it "routes to #show" do
    expect(get: "#{root_path}/admin/users/1")
    .to route_to(action: "show" ,controller: "v1/profiles", user_id: "1")
  end

  it "routes to #create" do
    expect(post: "http://api.example.com/v1/users/1/profiles")
    .to route_to(action: "create" ,controller: "v1/profiles", user_id: "1")
  end

end
