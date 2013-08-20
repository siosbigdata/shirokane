json.array!(@admin_graphs) do |admin_graph|
  json.extract! admin_graph, :name, :title, :analysis_type,:graph_type, :term, :y,:template,:useval,:linewidth
  json.url admin_graph_url(admin_graph, format: :json)
end
