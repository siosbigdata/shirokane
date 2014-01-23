# coding:utf-8
# グラフの新規追加時にデータベースに指定のテーブルが存在するか確認
# Author:: Kazuko Ohmura
# Date:: 2014.01.23

class GraphstableValidator<ActiveModel::EachValidator
  
  def validate_each(record,attribute,value)
    tbname = 'td_' + value
    Tdtable.table_name = tbname
    record.errors.add(attribute, I18n.t('error_graph_table_exists_message')) unless Tdtable.table_exists?
  end
end