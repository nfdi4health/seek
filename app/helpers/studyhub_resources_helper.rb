module StudyhubResourcesHelper
  
  def persistent_studyhub_resource_id_json(resource)
    label = "studyhub_resource.id"
    pp resource.resource_type
    label = "studyhub_resource.#{resource.resource_type}"

    url = URI.join(Seek::Config.site_base_host + '/', "#{resource.class.name.tableize}/", resource.id.to_s).to_s+".json"
    content_tag :p, class: :id do
      content_tag(:strong) do
        "Associated "+ t(label) + ':'
      end + ' ' + link_to(url, url)
    end
  end

end