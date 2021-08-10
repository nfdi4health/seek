module StudyhubResourcesHelper

  def associated_studyhub_resource_web_link(resource)

    label = "studyhub_resources.#{resource.studyhub_resource_type.key}"

    #todo change hardcoded url
    #url = URI.join("http://covid19.studyhub.nfdi4health.de/resource/", resource.id.to_s).to_s
    url = URI.join(Seek::Config.site_base_host + '/', "#{resource.class.name.tableize}/", resource.id.to_s).to_s + ".json"
    content_tag :p, class: :id do
      content_tag(:strong) do
        t(label) + ':'
      end + ' ' + link_to(url, url)
    end
  end

  def studyhub_resource_in_seek_id_json(resource)

    label = "studyhub_resources.id"
    url = URI.join(Seek::Config.site_base_host + '/', "#{resource.class.name.tableize}/", resource.id.to_s).to_s + ".json"
    content_tag :p, class: :id do
      content_tag(:strong) do
         t(label) + ':'
      end + ' ' + link_to(url, url)
    end
  end

  def studyhub_resource_descriptions (descriptions)
    html = ''
    if descriptions.any?

      html += '<div class="table-responsive">'
      html += '<table class="table table-striped table-hover steps">
      <thead>
      <tr>
        <th class="col-md-1">Description language</th>
        <th>Description Text</th>
      </tr>
      </thead>
      <tbody>'
      descriptions.each do |d|
        html += '<tr>'
        html += '<td class="description_language">' + d["description_language"] + '</td>'
        html += '<td class="description_text">' + d["description_text"] + '</td>'
      end
      html += '</tbody></table></div>'
    end
    html.html_safe
  end

  def studyhub_resource_associated_resource(types)
    html = ''
    types.each do |type|
      resource = StudyhubResource.find(type["id_id"])
      html += "<div class='nfdi_id_type'>"
      html += resource.studyhub_resource_type.title
      html += " "
      html += list_item_title(resource, {:include_avatar => false})
      html += " "
      html += type["id_relation_type"]
      html += " "
      html += (link_to "this resource", show_resource_path(@studyhub_resource) ).to_s
      html += "</div>"
    end
    html.html_safe
  end


  def studyhub_resource_titles (titles)
    html = ''
    if titles.any?
      html += '<div class="table-responsive">'
      html += '<table class="table table-striped table-hover steps">
      <thead>
      <tr>
        <th class="col-md-1">Title Language</th>
        <th>Title</th>
      </tr>
      </thead>
      <tbody>'
      titles.each do |d|
        html += '<tr>'
        html += '<td class="resource_language">' + d["resource_language"] + '</td>'
        html += '<td class="title">' + d["title"] + '</td>'
      end
      html += '</tbody></table></div>'
    end
    html.html_safe
  end


  def studyhub_resource_ids (ids)
    html = ''
    if ids.any?
      html += '<div class="table-responsive">'
      html += '<table class="table table-striped table-hover steps">
      <thead>
      <tr>
        <th class="col-md-1">ID</th>
        <th class="col-md-2">ID Date</th>
        <th class="col-md-3">ID Type</th>
        <th>Relation type</th>
      </tr>
      </thead>
      <tbody>'
      ids.each do |d|
        html += '<tr>'
        html += '<td class="id_id">' + d["id_id"] + '</td>'
        html += '<td class="id_date">' + d["id_date"] + '</td>'
        html += '<td class="id_type">' + d["id_type"] + '</td>'
        html += '<td class="id_relation_type">' + d["id_relation_type"] + '</td>'
      end
      html += '</tbody></table></div>'
    end
    html.html_safe
  end



  def studyhub_resource_roles (roles)
    html = ''
    if roles.any?
      html += '<div class="table-responsive">'
      html += '<table class="table table-striped table-hover steps">
      <thead>
      <tr>
        <th class="col-md-2">Name</th>
        <th class="col-md-2">Role Type</th>
        <th class="col-md-3">Email</th>
        <th class="col-md-2">Phone</th>
        <th class="col-md-3">Affiliation</th>
      </tr>
      </thead>
      <tbody>'
      roles.each do |d|
        html += '<tr>'
        html += '<td class="role_name">' + d["role_name"] + '</td>'
        html += '<td class="role_type">' + d["role_type"]
        html += '</td>'
        html += '<td class="role_email">' + d["role_email"] + '</td>'
        html += '<td class="role_phone">' + d["role_phone"] + '</td>'

        html += '<td class="role_affiliation">' + d["role_affiliation_name"]
        html += ',' + d["role_affiliation_city"] unless d["role_affiliation_city"].blank?
        html += ',' + d["role_affiliation_zip"] unless d["role_affiliation_zip"].blank?
        html += ',' + d["role_affiliation_country"] unless d["role_affiliation_country"].blank?
        html += '<br>' + d["role_affiliation_url"] unless d["role_affiliation_url"].blank?
        html += '</td>'
      end
      html += '</tbody></table></div>'
    end
    html.html_safe
  end

  def studyhub_custom_metadata_form_field_for_attribute(attribute, resource)

    base_type = attribute.sample_attribute_type.base_type
    clz = "custom_metadata_attribute_#{base_type.downcase}"
    element_name = "studyhub_resource[custom_metadata_attributes][data][#{attribute.title}]"

    value = resource[attribute.title] unless resource.nil?

    placeholder = "e.g. #{attribute.sample_attribute_type.placeholder}" unless attribute.sample_attribute_type.placeholder.blank?

    case base_type
    when Seek::Samples::BaseType::TEXT
      text_area_tag element_name, value, class: "form-control #{clz}"
    when Seek::Samples::BaseType::DATE_TIME
      content_tag :div, style:'position:relative' do
        text_field_tag element_name,value, data: { calendar: 'mixed' }, class: "calendar form-control #{clz}", placeholder: placeholder
      end
    when Seek::Samples::BaseType::DATE
      content_tag :div, style:'position:relative' do
        text_field_tag element_name, value, data: { calendar: true }, class: "calendar form-control #{clz}", placeholder: placeholder
      end
    when Seek::Samples::BaseType::BOOLEAN
      check_box_tag element_name, value, class: clz.to_s
    when Seek::Samples::BaseType::SEEK_DATA_FILE
      options = options_from_collection_for_select(DataFile.authorized_for(:view), :id,
                                                   :title, value.try(:[],'id'))
      select_tag(element_name, options, include_blank: !attribute.required?, class: "form-control #{clz}")
    when Seek::Samples::BaseType::CV
      controlled_vocab_form_field attribute, element_name, value
    else
      text_field_tag element_name, value, class: "form-control #{clz}", placeholder: placeholder
    end
  end

  def grouped_options_for_studyhub_resource_type
    study = []
    non_study = []

    StudyhubResourceType.all.select(&:is_studytype?).each do |x|
      study << [x.title, x.key]
    end

    StudyhubResourceType.all.reject(&:is_studytype?).each do |x|
      non_study << [x.title, x.key]
    end

    { 'Study Type' => study,'Non Study Type' => non_study }
  end

end