
module StudyhubResourcesHelper


  #@todo for testing reason, remove it later.
  def persistent_resource_id_json(resource)
    # FIXME: this contains some duplication of Seek::Rdf::RdfGeneration#rdf_resource - however not every model includes that Module at this time.
    # ... its also a bit messy handling the version
    url = URI.join(Seek::Config.site_base_host + '/', "#{resource.class.name.tableize}/", resource.id.to_s).to_s+".json"


    content_tag :p, class: :id do
      content_tag(:strong) do
        t('seek_id') + ':'
      end + ' ' + link_to(url, url)
    end
  end

end