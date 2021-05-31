module StudyhubResourcesHelper

  def associated_studyhub_resource_web_link(resource)

    label = "studyhub_resources.#{resource.studyhub_resource_type.key}"

    #todo change hardcoded url
    #url = URI.join("http://covid19.studyhub.nfdi4health.de/resource/", resource.id.to_s).to_s
    url = URI.join(Seek::Config.site_base_host + '/', "#{resource.class.name.tableize}/", resource.id.to_s).to_s+".json"
    content_tag :p, class: :id do
      content_tag(:strong) do
        t(label) + ':'
      end + ' ' + link_to(url, url)
    end
  end

  def studyhub_resource_in_seek_id_json(resource)

    label = "studyhub_resources.id"
    url = URI.join(Seek::Config.site_base_host + '/', "#{resource.class.name.tableize}/", resource.id.to_s).to_s+".json"
    content_tag :p, class: :id do
      content_tag(:strong) do
         t(label) + ':'
      end + ' ' + link_to(url, url)
    end
  end
end