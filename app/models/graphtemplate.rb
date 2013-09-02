#coding: utf-8
# Admin::Groupgraph Model
# Author:: Kazuko Ohmura
# Date:: 2013.08.05

# グラフ用テンプレートも出る
# == テーブル作成
# rails generate model graphtemplate name:string linecolor:string bgfrom:string bgto:string textcolor:strin
# == サンプルテンプレート
#Graphtemplate.create(:name=>'aliceblue-black',:linecolor => "#000000",:bgfrom => "#f0f8ff",:bgto => "#f0f8ff",:textcolor => "#000000" ,:useshadow=>"0")
#Graphtemplate.create(:name=>'aliceblue-black-s',:linecolor => "#000000",:bgfrom => "#f0f8ff",:bgto => "#f0f8ff",:textcolor => "#000000" ,:useshadow=>"1")
#Graphtemplate.create(:name=>'aliceblue-dimgray',:linecolor => "#696969",:bgfrom => "#f0f8ff",:bgto => "#f0f8ff",:textcolor => "#696969" ,:useshadow=>"0")
#Graphtemplate.create(:name=>'aliceblue-dimgray-s',:linecolor => "#696969",:bgfrom => "#f0f8ff",:bgto => "#f0f8ff",:textcolor => "#696969" ,:useshadow=>"1")
#Graphtemplate.create(:name=>'black-red',:linecolor => "#ff0000",:bgfrom => "#687478",:bgto => "#222222",:textcolor => "#ff0000",:useshadow=>"0")
#Graphtemplate.create(:name=>'black-red-s',:linecolor => "#ff0000",:bgfrom => "#687478",:bgto => "#222222",:textcolor => "#ff0000",:useshadow=>"1")
#Graphtemplate.create(:name=>'black-white',:linecolor => "#ffffff",:bgfrom => "#687478",:bgto => "#222222",:textcolor => "#ffffff",:useshadow=>"0")
#Graphtemplate.create(:name=>'black-white-s',:linecolor => "#ffffff",:bgfrom => "#687478",:bgto => "#222222",:textcolor => "#ffffff",:useshadow=>"1")
#Graphtemplate.create(:name=>'cornsilk-dimgray',:linecolor => "#696969",:bgfrom => "#fff8dc",:bgto => "#fff8dc",:textcolor => "#696969",:useshadow=>"0")
#Graphtemplate.create(:name=>'cornsilk-dimgray-s',:linecolor => "#696969",:bgfrom => "#fff8dc",:bgto => "#fff8dc",:textcolor => "#696969",:useshadow=>"1")
#Graphtemplate.create(:name=>'green-green',:linecolor => "#003300",:bgfrom => "#00ff99",:bgto => "#339933",:textcolor => "#003300",:useshadow=>"0")
#Graphtemplate.create(:name=>'green-green-s',:linecolor => "#003300",:bgfrom => "#00ff99",:bgto => "#339933",:textcolor => "#003300",:useshadow=>"0")
#Graphtemplate.create(:name=>'lavender-dimgray',:linecolor => "#696969",:bgfrom => "#e6e6fa",:bgto => "#e6e6fa",:textcolor => "#696969",:useshadow=>"0")
#Graphtemplate.create(:name=>'lavender-dimgray-s',:linecolor => "#696969",:bgfrom => "#e6e6fa",:bgto => "#e6e6fa",:textcolor => "#696969",:useshadow=>"1")
#Graphtemplate.create(:name=>'lavenderblush-dimgray',:linecolor => "#696969",:bgfrom => "#fff0f5",:bgto => "#fff0f5",:textcolor => "#696969" ,:useshadow=>"0")
#Graphtemplate.create(:name=>'lavenderblush-dimgray-s',:linecolor => "#696969",:bgfrom => "#fff0f5",:bgto => "#fff0f5",:textcolor => "#696969" ,:useshadow=>"1")
#Graphtemplate.create(:name=>'lightcyan-dimgray',:linecolor => "#696969",:bgfrom => "#e0ffff",:bgto => "#e0ffff",:textcolor => "#696969" ,:useshadow=>"0")
#Graphtemplate.create(:name=>'lightcyan-dimgray-s',:linecolor => "#696969",:bgfrom => "#e0ffff",:bgto => "#e0ffff",:textcolor => "#696969" ,:useshadow=>"1")
#Graphtemplate.create(:name=>'lightsteelblue-dimgray',:linecolor => "#696969",:bgfrom => "#e0ffff",:bgto => "#b0c4de",:textcolor => "#696969" ,:useshadow=>"0")
#Graphtemplate.create(:name=>'lightsteelblue-dimgray-s',:linecolor => "#696969",:bgfrom => "#e0ffff",:bgto => "#b0c4de",:textcolor => "#696969" ,:useshadow=>"1")
#Graphtemplate.create(:name=>'mistyrose-dimgray',:linecolor => "#696969",:bgfrom => "#ffe4e1",:bgto => "#ffe4e1",:textcolor => "#696969" ,:useshadow=>"0")
#Graphtemplate.create(:name=>'mistyrose-dimgray-s',:linecolor => "#696969",:bgfrom => "#ffe4e1",:bgto => "#ffe4e1",:textcolor => "#696969" ,:useshadow=>"1")
#Graphtemplate.create(:name=>'snow-dimgray',:linecolor => "#696969",:bgfrom => "#fffafa",:bgto => "#fffafa",:textcolor => "#696969",:useshadow=>"0")
#Graphtemplate.create(:name=>'snow-dimgray-s',:linecolor => "#696969",:bgfrom => "#fffafa",:bgto => "#fffafa",:textcolor => "#696969",:useshadow=>"1")
#Graphtemplate.create(:name=>'white-black',:linecolor => "#000000",:bgfrom => "#ffffff",:bgto => "#ffffff",:textcolor => "#000000",:useshadow=>"0")
#Graphtemplate.create(:name=>'white-black-s',:linecolor => "#000000",:bgfrom => "#ffffff",:bgto => "#ffffff",:textcolor => "#000000",:useshadow=>"1")
#Graphtemplate.create(:name=>'white-dimgray',:linecolor => "#696969",:bgfrom => "#ffffff",:bgto => "#ffffff",:textcolor => "#696969" ,:useshadow=>"0")
#Graphtemplate.create(:name=>'white-dimgray-s',:linecolor => "#696969",:bgfrom => "#ffffff",:bgto => "#ffffff",:textcolor => "#696969" ,:useshadow=>"1")
#Graphtemplate.create(:name=>'yellow-orange',:linecolor => "#ff6600",:bgfrom => "#ffff66",:bgto => "#ffcc33",:textcolor => "#ff6600",:useshadow=>"0")
#Graphtemplate.create(:name=>'yellow-orange-s',:linecolor => "#ff6600",:bgfrom => "#ffff66",:bgto => "#ffcc33",:textcolor => "#ff6600",:useshadow=>"1")
class Graphtemplate < ActiveRecord::Base
end
