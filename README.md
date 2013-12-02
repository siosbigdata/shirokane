OSS Dashboard
=========
This system is a dashboard of BigData graph.  

Install
=========
* Prepare the environment to the database which can be connected to the Rails.
* Please perform the following settings in your environment
    $ git clone https://github.com/siosbigdata/shirokane.git newsite
    $ vi config/database.yml (Please prepare by yourself is not included in the project.)
    $ vi config/environments/production.rb (Fix the host of the last line)
    $ cd newsite
    $ mkdir log
    $ chmod 777 log
    $ bundle install
    $ rake db:setup

Create Graph
=========
* create table
    If you want to make "test01" table in database (ex. postgresql)
    > create table td_test01 (td_time timestamp with time zone,td_count decimal);
    
    $ rails c
    > Graph.create(:name=>"test01",:title=>"テスト０１",:analysis_type=>0,:graph_type=>0,:term=>2,:y=>"count",:y_min=>0,:y_max_time=>100,:y_max_day=>1000,:y_max_month=>1000,:useval=>0,:useshadow=>0,:usetip => 0,:linewidth=>2,:template=>"white-dimgray",:usepredata=>0,:uselastyeardata=>0)
    
Use Treasure Data Push
=========
* One time.
    td query --result 'postgresql://newuser:newusernewuser@175.41.253.164/newdb/td_access'  -w -d sios_web    "SELECT TD_TIME_FORMAT(time, 'yyyy-MM-dd HH:00:00 +09:00') as td_time , COUNT(1) as td_count FROM www_access GROUP BY TD_TIME_FORMAT(time, 'yyyy-MM-dd HH:00:00 +09:00') " 

* If you run this push on a regular basis,you need to make "td shced"

Attention
=========
* This system takes advantage of PostgreSQL.  
* This system is made ​​by the basis of Ruby on Rails4.  
* This system is compatible with Japanese and English. Please create a language file when using other languages​​.  
* Please be careful config/database.yml file because not enough.

License
=========
* Copyright &copy; 2013 SIOS Technology,Inc.  
* Distributed under the [MIT License][MIT].  

* Part of chart  
[Copyright (c) 2013 Toshiro Takahashi][CCCHART]  
  
[MIT]: http://www.opensource.org/licenses/mit-license.php  
[CCCHART]: http://ccchart.com/  
