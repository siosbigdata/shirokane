json.array!(@admin_graphs) do |admin_graph|
  json.extract! admin_graph, :name, :title, :analysis_type,:graph_type, :term, :y,:y_min,:y_max_time,:y_max_day,:y_max_month,:template,:useval,:useshadow,:usetip,:linewidth
  json.url admin_graph_url(admin_graph, format: :json)
end
