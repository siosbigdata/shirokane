# -*- conding: utf-8 -*-
require 'spec_helper'

describe "login routing" do

  it "routes to #index" do
    expect(get: "#{root_path}/login")
    .to route_to(action: "index" ,controller: "login")
  end

  it "routes to #create" do
    expect(post: "#{root_path}/login")
    .to route_to(action: "create" ,controller: "login")
  end

end
