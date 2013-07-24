json.array!(@admin_graphs) do |admin_graph|
  json.extract! admin_graph, :name, :title, :type, :term, :x, :y
  json.url admin_graph_url(admin_graph, format: :json)
end
