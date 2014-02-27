# -*- coding:utf-8 -*-
require 'factory_girl'

FactoryGirl.define do
  factory :login_user, class: User do
    name "dumy administrator tarou"
    mail "dumy_administrator@dumy.com"
    password "dumydumydumy"
    password_confirmation "dumydumydumy"
    title "dumy_administrator"
    group_id 1
    admin true
  end

  factory :admin_user, class: User do
    name "dumy tarou"
    mail "dumy_admin@dumy.com"
    password "dumydumydumy"
    password_confirmation "dumydumydumy"
    title "dumy"
    group_id 1
    admin true
  end

  factory :user, class: User do
    name "dumy tarou"
    mail "dumy@dumy.com"
    password "dumydumydumy"
    password_confirmation "dumydumydumy"
    title "dumy"
    group_id 1
    admin false
  end

  factory :admin_users, class: User do
    sequence(:name) { |i| "admin_dumy #{i}rou" }
    sequence(:mail) { |i| "admin_dumy-#{i}@dumy.com" }
    password "dumydumydumy"
    password_confirmation "dumydumydumy"
    sequence(:title) { |i| "admin_dumy-#{i}" }
    group_id 1
    admin true
  end

  factory :users, class: User do
    sequence(:name) { |i| "dumy #{i}rou" }
    sequence(:mail) { |i| "dumy-#{i}@dumy.com" }
    password "dumydumydumy"
    password_confirmation "dumydumydumy"
    sequence(:title) { |i| "dumy-#{i}" }
    group_id 1
    admin false
  end
end
