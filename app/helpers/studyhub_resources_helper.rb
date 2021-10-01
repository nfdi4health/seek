module StudyhubResourcesHelper

  def associated_studyhub_resource_web_link(resource)

    label = "studyhub_resources.#{resource.studyhub_resource_type.key}"

    #todo change hardcoded url
    #url = URI.join("http://covid19.studyhub.nfdi4health.de/resource/", resource.id.to_s).to_s
    url = URI.join(Seek::Config.site_base_host + '/', "#{resource.class.name.tableize}/", resource.id.to_s).to_s + '.json'
    content_tag :p, class: :id do
      content_tag(:strong) do
        t(label) + ':'
      end + ' ' + link_to(url, url)
    end
  end

  def studyhub_resource_in_seek_id_json(resource)

    label = 'studyhub_resources.id'
    url = URI.join(Seek::Config.site_base_host + '/', "#{resource.class.name.tableize}/", resource.id.to_s).to_s + '.json'
    content_tag :p, class: :id do
      content_tag(:strong) do
        t(label) + ':'
      end + ' ' + link_to(url, url)
    end
  end


  def studyhub_resource_associated_resource(types)
    html = ''
    types.each do |type|
      resource = StudyhubResource.find(type['id_id'])
      html += "<div class='nfdi_id_type'>"
      html += resource.studyhub_resource_type.title
      html += ' '
      html += list_item_title(resource, {:include_avatar => false})
      html += ' '
      html += type['id_relation_type']
      html += ' '
      html += (link_to 'this resource', show_resource_path(@studyhub_resource) ).to_s
      html += '</div>'
    end
    html.html_safe
  end


  def studyhub_resource_items(items,item_type)
    html = ''
    if items.any?
      html += '<div class="table-responsive">'
      html += '<table class="table table-striped table-hover steps">
      <thead>
      <tr>
        <th class="col-md-1">'+item_type.capitalize+' Language</th>
        <th>'+item_type.capitalize+'</th>
      </tr>
      </thead>
      <tbody>'
      items.each do |d|
        html += '<tr>'
        html += '<td class="'+item_type+'_language">' + d[item_type+'_language'] + '</td>'
        html += '<td class="'+item_type+'">' + d[item_type] + '</td>'
      end
      html += '</tbody></table></div>'
    end
    html.html_safe
  end

  def show_resource_stage(resource)
    html = '<p class="stage alert alert-info"><strong>Working stage: </strong>'
    html += StudyhubResource.get_stage_wording(resource.stage)
    html += '</p>'
    html.html_safe
  end

  def studyhub_resource_nfdi_ids (ids)
    html = ''
    if ids.any?
      html += '<div class="table-responsive">'
      html += '<table class="table table-striped table-hover steps">
      <thead>
      <tr>
         <th class="col-md-2">Resource type</th>
          <th class="col-md-2">ID</th>
           <th>Title</th>
      </tr>
      </thead>
      <tbody>'
      ids.each do |d|
        html += '<tr>'
        html += '<td class="id_resource_type">' + StudyhubResource.find(d['id_id']).studyhub_resource_type.title + '</td>'
        html += '<td class="id_id">' + 'NFDI4Health-'+d['id_id'] + '</td>'
        # html += '<td class="id_title">' + StudyhubResource.find(d["id_id"]).title + '</td>'
        html += '<td class="id_title">' + (link_to StudyhubResource.find(d['id_id']).title, show_resource_path(StudyhubResource.find(d['id_id'])) ).to_s + '</td>'
        html += '</tr>'
      end
      html += '</tbody></table></div>'
    end
    html.html_safe
  end


  def studyhub_resource_other_ids (ids)
    html = ''
    if ids.any?
      html += '<div class="table-responsive">'
      html += '<table class="table table-striped table-hover steps">
      <thead>
      <tr>
        <th class="col-md-2">Relation type</th>
        <th class="col-md-2">ID Type</th>
        <th class="col-md-3">ID</th>
        <th>ID Resource Type</th>
        <th>ID Date</th>
      </tr>
      </thead>
      <tbody>'
      ids.each do |d|
        html += '<tr>'
        html += '<td class="id_relation_type">' + (d['id_relation_type'].nil? ? '' : d['id_relation_type'].underscore.humanize ) + '</td>'
        html += '<td class="id_type">' + d['id_type'] + '</td>'
        html += '<td class="id_id">' + d['id_id'] + '</td>'
        html += '<td class="id_resource_type_general">' + d['id_resource_type_general'] + '</td>'
        html += '<td class="id_date">' + d['id_date'] + '</td>'
        html += '</tr>'
      end
      html += '</tbody></table></div>'
    end
    html.html_safe
  end

  def studyhub_resource_roles (roles)
    html = ''
    if roles.any?
      roles.each do |d|
        html += '<div style="margin-bottom: 40px">'

        case d['role_name_type']
        when 'Personal'
          role_name = d['role_name_personal_title'] + ' ' + d['role_name_personal_given_name']+ ' '+ d['role_name_personal_family_name']
        when 'Organisational'
          role_name = d['role_name_organisational']
        end

        html += '<p class="role_type"><strong>Role Type: </strong>'+d['role_type']+'</p>'
        html += '<p class="role_name_type"><strong>Role Name Type: </strong>'+d['role_name_type']+'</p>'
        html += '<p class="role_name"><strong>Name: </strong>'+role_name +'</p>'

        html += '<p class="role_email"><strong>Email: </strong>'+d["role_email"] +'</p>' unless d["role_email"].blank?
        html += '<p class="role_phone"><strong>Phone: </strong>'+d["role_phone"] +'</p>' unless d["role_phone"].blank?
        html += '<p class="role_name_identifier"><strong>Identifier: </strong>'+d["role_name_identifier"] +'</p>' unless d["role_name_identifier"].blank?
        html += '<p class="role_name_identifier_scheme"><strong>Identifier Scheme: </strong>'+d["role_name_identifier_scheme"] +'</p>' unless d["role_name_identifier_scheme"].blank?

        html += '<p class="role_affiliation_name"><strong>Affiliation: </strong>'+d["role_affiliation_name"]+'</p>' unless d["role_affiliation_name"].blank?
        html += '<p class="role_affiliation_address"><strong>Address: </strong>'+d["role_affiliation_address"]+'</p>' unless d["role_affiliation_address"].blank?
        html += '<p class="role_affiliation_web_page"><strong>Webpage: </strong>'+d["role_affiliation_web_page"]+'</p>' unless d["role_affiliation_web_page"].blank?
        html += '<p class="role_affiliation_identifier"><strong>Identifier: </strong>'+d["role_affiliation_identifier"]+'</p>' unless d["role_affiliation_identifier"].blank?
        html += '<p class="role_name_identifier_scheme"><strong>Identifier Scheme: </strong>'+d["role_name_identifier_scheme"]+'</p>' unless d["role_name_identifier_scheme"].blank?
        html +=  '</p>'
        html += '</div>'
      end
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

  def controlled_vocab_form_field(attribute, element_name, value)
    if attribute.sample_controlled_vocab.sample_controlled_vocab_terms.count < Seek::Config.cv_dropdown_limit

      options = options_from_collection_for_select(
        attribute.sample_controlled_vocab.sample_controlled_vocab_terms,
        :label, :label,
        value
      )
      select_tag element_name,
                 options,
                 class: 'form-control',
                 include_blank: 'Please select...'
    else
      scv_id = attribute.sample_controlled_vocab.id
      existing_objects = []
      existing_objects << Struct.new(:id, :name).new(value, value) if value
      objects_input(element_name, existing_objects,
                    typeahead: { query_url: typeahead_sample_controlled_vocabs_path + "?query=%QUERY&scv_id=#{scv_id}",
                                 handlebars_template: 'typeahead/controlled_vocab_term' },
                    limit: 1)
    end
  end

  def process_role_error_messags(index)

    role = {}

    if (@error_keys.include? "roles[#{index}]['role_type']")
      role["role_type"] = @studyhub_resource.errors.messages["roles[#{index}]['role_type']".to_sym].first
    end

    if (@error_keys.include? "roles[#{index}]['role_name_type']")
      role["role_name_type"] = @studyhub_resource.errors.messages["roles[#{index}]['role_name_type']".to_sym].first
    end

    if (@error_keys.include? "roles[#{index}]['role_name_personal_title']")
      role["role_name_personal_title"] = @studyhub_resource.errors.messages["roles[#{index}]['role_name_personal_title']".to_sym].first
    end

    if (@error_keys.include? "roles[#{index}]['role_name_personal_given_name']")
      role["role_name_personal_given_name"] = @studyhub_resource.errors.messages["roles[#{index}]['role_name_personal_given_name']".to_sym].first
    end

    if (@error_keys.include? "roles[#{index}]['role_name_personal_family_name']")
      role["role_name_personal_family_name"] = @studyhub_resource.errors.messages["roles[#{index}]['role_name_personal_family_name']".to_sym].first
    end

    if (@error_keys.include? "roles[#{index}]['role_name_organisational']")
      role["role_name_organisational"] = @studyhub_resource.errors.messages["roles[#{index}]['role_name_organisational']".to_sym].first
    end

    if (@error_keys.include? "roles[#{index}]['role_name_identifier_scheme']")
      role["role_name_identifier_scheme"] = @studyhub_resource.errors.messages["roles[#{index}]['role_name_identifier_scheme']".to_sym].first
    end

    if (@error_keys.include? "roles[#{index}]['role_affiliation_identifier_scheme']")
      role["role_affiliation_identifier_scheme"] = @studyhub_resource.errors.messages["roles[#{index}]['role_affiliation_identifier_scheme']".to_sym].first
    end

    role
  end

  def process_id_error_messags(index)

    id = {}

    if (@error_keys.include? "ids[#{index}]['id_relation_type']")
      id["id_relation_type"] = @studyhub_resource.errors.messages["ids[#{index}]['id_relation_type']".to_sym].first
    end

    if (@error_keys.include? "ids[#{index}]['id_type']")
      id["id_type"] = @studyhub_resource.errors.messages["ids[#{index}]['id_type']".to_sym].first
    end

    id
  end

end