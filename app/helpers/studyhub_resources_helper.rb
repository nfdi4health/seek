module StudyhubResourcesHelper

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
        <th>ID Resource Type</th>
        <th class="col-md-2">ID Type</th>
        <th class="col-md-3">ID</th>
        <th>ID Date</th>
        <th class="col-md-2">Relation type</th>
      </tr>
      </thead>
      <tbody>'
      ids.each do |d|
        html += '<tr>'
        html += '<td class="id_resource_type_general">' + d['id_resource_type_general'] + '</td>'
        html += '<td class="id_type">' + d['id_type'] + '</td>'
        html += '<td class="id_id">' + d['id_id'] + '</td>'
        html += '<td class="id_date">' + d['id_date'] + '</td>'
        html += '<td class="id_relation_type">' + (d['id_relation_type'].nil? ? '' : d['id_relation_type'].underscore.humanize ) + '</td>'
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
        html += '<div class="row">'
        html += '<div class="column">'
        # html += '<p class="role_type"><strong>'+d['role_type']+': </strong>'+role_name+'('+d['role_name_type']+')</p>'
        html += '<p class="role_type"><strong>'+d['role_type']+': </strong>'+role_name(d)+'</p>'
        html += '<p class="role_email"><strong>Email: </strong>'+d['role_email'] +'</p>' unless d['role_email'].blank?
        html += '<p class="role_phone"><strong>Phone: </strong>'+d['role_phone'] +'</p>' unless d['role_phone'].blank?
        html +=  role_schema_link(d,'name')
        html += '</div>'
        html += '<div class="column">'
        html += '<p class="role_affiliation_name"><strong>Affiliation: </strong>'+d['role_affiliation_name']+'</p>' unless d['role_affiliation_name'].blank?
        html += '<p class="role_affiliation_address"><strong>Address: </strong>'+d['role_affiliation_address']+'</p>' unless d['role_affiliation_address'].blank?
        html += '<p class="role_affiliation_web_page"><strong>Webpage: </strong>'+ link_to(d['role_affiliation_web_page'].truncate(100), d['role_affiliation_web_page'], target: :_blank ) +'</p>' unless d['role_affiliation_web_page'].blank?
        html +=  role_schema_link(d,'affiliation')
        html +=  '</p>'
        html += '</div>'
        html += '</div>'
        html += '<hr>'
      end
    end
    html.html_safe
  end

  def role_schema_link(role,type)
    html = ''
    identifier = 'role_'+type+'_identifier'
    identifiers = 'role_'+type+'_identifiers'
    identifier_scheme = 'role_'+type+'_identifier_scheme'

    if role[identifiers].size > 0
      html += '<p class="role_'+type+'_identifiers"><strong>'+(type=='name'? 'personal' : type).capitalize+' '+'identifier'.pluralize( role[identifiers].size )+':</strong></p>'
      role[identifiers].each do |d|
        id = d[identifier]
        case d[identifier_scheme]
        when 'ORCID'
          logo = image(:orcid_id)
          html += '<p class="'+identifier_scheme+'"><strong>ORCID: </strong>'+link_to(logo +' https://orcid.org/'+id, 'https://orcid.org/'+id, target: '_blank') +'</p>' unless id.blank?
        when 'ROR'
          html += '<p class="'+identifier_scheme+'"><strong>ROR: </strong>'+link_to('https://ror.org/'+id, 'https://ror.org/'+id, target: '_blank') +'</p>' unless id.blank?
        when 'GRID'
          html += '<p class="'+identifier_scheme+'"><strong>GRID: </strong>'+link_to('https://www.grid.ac/institutes/'+id, 'https://www.grid.ac/institutes/'+id, target: '_blank') +'</p>' unless id.blank?
        when 'ISNI'
          html += '<p class="'+identifier_scheme+'"><strong>ISNI: </strong>'+link_to('https://isni.org/isni/'+id, 'https://isni.org/isni/'+id, target: '_blank') +'</p>' unless id.blank?
        end
      end
    end

    html
  end


  def studyhub_custom_metadata_form_field_for_attribute(attribute, resource, index = nil)

    base_type = attribute.sample_attribute_type.base_type
    clz = "custom_metadata_attribute_#{base_type.downcase}"

    if index.nil?
      element_name = "studyhub_resource[custom_metadata_attributes][data][#{attribute.title}]"
    else
      key = get_attribute_key(attribute.title)
      element_name = "studyhub_resource[custom_metadata_attributes][data][#{key}][#{attribute.title}][#{index}]"
    end

    if index.nil?
      value = resource[attribute.title] unless resource.nil?
    elsif index == 'row-template'
      value = nil
    else
      value = resource[key][index.to_i][attribute.title] unless resource.nil? || resource[key][index.to_i].nil?
    end

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

  def resource_keywords(value)
    html = ''

    if value.any?
      value.each do |d|
        html += d['resource_keywords_label']
        html += '('+d['resource_keywords_label_code']+')' unless d['resource_keywords_label_code'].blank?
        html += '; '
      end
    end
    html.html_safe
  end

  def process_role_error_messags(index)

    role = {}


    @error_keys.each do |key|

      if (key.include? 'role_type')
        role['role_type'] = @studyhub_resource.errors.messages["roles[#{index}]['role_type']".to_sym].first
      end

      if (key.include? 'role_name_type')
        role['role_name_type'] = @studyhub_resource.errors.messages["roles[#{index}]['role_name_type']".to_sym].first
      end

      if (key.include? 'role_name_personal_title')
        role['role_name_personal_title'] = @studyhub_resource.errors.messages["roles[#{index}]['role_name_personal_title']".to_sym].first
      end

      if (key.include? 'role_name_personal_given_name')
        role['role_name_personal_given_name'] = @studyhub_resource.errors.messages["roles[#{index}]['role_name_personal_given_name']".to_sym].first
      end

      if (key.include? 'role_name_personal_family_name')
        role['role_name_personal_family_name'] = @studyhub_resource.errors.messages["roles[#{index}]['role_name_personal_family_name']".to_sym].first
      end

      if (key.include? 'role_name_organisational')
        role['role_name_organisational'] = @studyhub_resource.errors.messages["roles[#{index}]['role_name_organisational']".to_sym].first
      end

      if (key.include? 'role_affiliation_web_page')
        role['role_affiliation_web_page'] = @studyhub_resource.errors.messages["roles[#{index}]['role_affiliation_web_page']".to_sym].first
      end
    end

    role
  end

  def process_multi_attributes_single_row_error_messags(key)
    error = {}
    case key

    when 'study_conditions'
      error['study_conditions_classification'] = {}
      @error_keys.each_with_index  do |key|
          if (key.include? 'study_conditions_classification')
            index = key[-2,1].to_i
            error['study_conditions_classification'][index] = @studyhub_resource.errors.messages[key.to_sym].first
          end
      end
    when 'outcomes'
      error['study_outcome_type'] = {}
      @error_keys.each_with_index  do |key|
        if (key.include? 'study_outcome_type')
          index = key[-2,1].to_i
          error['study_outcome_type'][index] = @studyhub_resource.errors.messages[key.to_sym].first
        end
      end
    when 'interventional_study_design_arms'
      error['study_arm_group_type'] = {}
      @error_keys.each_with_index  do |key|
        if (key.include? 'study_arm_group_type')
          index = key[-2,1].to_i
          error['study_arm_group_type'][index] = @studyhub_resource.errors.messages[key.to_sym].first
        end
      end
    end

    error
  end


  def process_role_id_error_messags(index,type)

    role_type_identifier_scheme  = "role_#{type}_identifier_scheme"

    role = {}
    role[role_type_identifier_scheme]= {}
    role[role_type_identifier_scheme][index] = {}


    @error_keys.each do |key|
      if (key.include? "role_#{type}_identifier_scheme")
        id_index = key[-2,1].to_i
        role[role_type_identifier_scheme][index][id_index] = if index == 'row-template'
                                                               nil
                                                             else
                                                               @studyhub_resource.errors.messages[key.to_sym].first
                                                             end

      end
    end

    role

  end

  def process_id_error_messags(index)

    id = {}

    if (@error_keys.include? "ids[#{index}]['id_relation_type']")
      id['id_relation_type'] = @studyhub_resource.errors.messages["ids[#{index}]['id_relation_type']".to_sym].first
    end

    if (@error_keys.include? "ids[#{index}]['id_type']")
      id['id_type'] = @studyhub_resource.errors.messages["ids[#{index}]['id_type']".to_sym].first
    end

    id
  end



  private

  def get_attribute_key(value)
    StudyhubResource::MULTI_ATTRIBUTE_FIELDS_LIST_STYLE.select{|key, array| array.include? value }.keys.first
  end

  def role_name(d)
    case d['role_name_type']
    when 'Personal'
      role_name = d['role_name_personal_title'] + ' ' + d['role_name_personal_given_name'] + ' ' + d['role_name_personal_family_name']
    when 'Organisational'
      role_name = d['role_name_organisational']
    end
    role_name
  end

end