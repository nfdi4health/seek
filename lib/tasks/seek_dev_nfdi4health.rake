require 'json'
namespace :seek_dev_nfdi4health do


  task :update_policy_permission_a_contributor, [:path] => [:environment] do |t, args|
    user_id = args.path
    puts "You want to grant user ID =  #{user_id} the manage right..."
    puts 'Update policy and permission for Studyhub Resource ... '
    StudyhubResource.all.map(&:id).each do |id|
      permission =  StudyhubResource.find(id).policy.permissions.where(contributor_type: "Person", contributor_id: user_id).first_or_initialize
      pp permission
      permission.update_attributes(access_type:4)
    end
  end

  task(update_studyhub_resource_seeds: :environment) do

    puts 'Update studyhub resource seeds ... '
    puts 'Update NFDI4Health Resource Language ... '
    SampleControlledVocabTerm.where(label: 'EN').first.update_attributes(label:'EN (English)') unless SampleControlledVocabTerm.where(label: 'EN').blank?
    SampleControlledVocabTerm.where(label: 'DE').first.update_attributes(label:'DE (German)') unless SampleControlledVocabTerm.where(label: 'EN').blank?
    SampleControlledVocabTerm.where(label: 'ES').first.update_attributes(label:'ES (Spanish)') unless SampleControlledVocabTerm.where(label: 'EN').blank?
    SampleControlledVocabTerm.where(label: 'FR').first.update_attributes(label:'FR (French)') unless SampleControlledVocabTerm.where(label: 'EN').blank?
    puts 'Update NFDI4Health Study Status When Intervention ... '
    SampleControlledVocabTerm.where(label: 'Follow-up ongoing').first.update_attributes(label:'follow-up ongoing') unless SampleControlledVocabTerm.where(label: 'Follow-up ongoing').blank?


  end

  task(update_resource_json: :environment) do

    puts 'Update resource_json ... '

    StudyhubResource.all.each do |sr|
      puts 'id='+sr.id.to_s+'('+sr.studyhub_resource_type.title+'):'
      json = sr.resource_json


    puts ' ----------------------------------------- '
    puts 'step 1: move resource properties one level up ...'
      if json.key?('resource')
        json['resource'].keys.each do |key|
          json[key] = json['resource'][key]
        end
        json.delete('resource')
      end

    puts ' ----------------------------------------- '
    puts 'step 2: add provenance properties...'
      unless json.key?('provenance')
        json['provenance']={}
        json['provenance']['data_source'] = 'Manually collected'
      end

    puts ' ----------------------------------------- '
    puts 'step 3: update user right related properties...'
    # puts 'resource_use_rights_label:'+json['resource_use_rights_label']
      unless json['resource_use_rights_label']&.start_with?('CC')
        StudyhubResource::REQUIRED_FIELDS_RESOURCE_USE_RIGHTS.each do |name|
          if json.key?(name)
            json.delete(name)
          end
        end
      end


    puts ' ----------------------------------------- '
    puts 'step 4: merge merge "study_type_interventional" and "study_type_non_interventional" into "study_type" ...'

      if (sr.is_studytype?)
        json['study_design']['study_type'] = if !json['study_design']['study_type_non_interventional'].blank?
                                               json['study_design']['study_type_non_interventional']
        elsif !json['study_design']['study_type_interventional'].blank?
          json['study_design']['study_type_interventional']
        else
          ''
                                             end
        # pp json['study_design']['study_type']
        json['study_design'].delete('study_type_non_interventional')
        json['study_design'].delete('study_type_interventional')
      end


    puts ' ----------------------------------------- '
    puts 'step 5:  remove "role_name_identifiers" when the "role_name_type" = "Organisational" ...'
      json['roles'].each do |role|
        if role['role_name_type'] == 'Organisational'
          # pp "role_name_personal_title" if role.has_key? ('role_name_personal_title')
          # pp "role_name_personal_given_name" if role.has_key? ('role_name_personal_given_name')
          # pp "role_name_personal_family_name" if role.has_key? ('role_name_personal_family_name')
          # pp "role_name_identifiers" if role.has_key? ('role_name_identifiers')

          role.delete('role_name_personal_title') if role.key? ('role_name_personal_title')
          role.delete('role_name_personal_given_name') if role.key? ('role_name_personal_given_name')
          role.delete('role_name_personal_family_name') if role.key? ('role_name_personal_family_name')
          role.delete('role_name_identifiers') if role.key? ('role_name_identifiers')

        end

        if role['role_name_type'] == 'Personal'
          # pp "role_name_organisational" if role.has_key? ('role_name_organisational')
          role.delete('role_name_organisational') if role.key? ('role_name_organisational')
        end
      end


    puts ' ----------------------------------------- '
    puts 'step 6:  id_date format update...'
    #   pp json['ids'].size
      unless json['ids'].empty?
        json['ids'].each do |id|
          id['id_date'] = if id['id_date'].blank?
                            nil
          else
            Date.parse(id['id_date']).strftime("%d.%m.%Y") end
          # pp "after:id_date:"+id['id_date'].inspect
        end
      end

    puts ' ----------------------------------------- '
    puts 'step 7:  study_start_date and study_end_date format update...'

      if sr.is_studytype?
        json['study_design']['study_start_date'] = json['study_design']['study_start_date'].blank? ? nil : Date.parse(json['study_design']['study_start_date']).strftime("%d.%m.%Y")
        json['study_design']['study_end_date'] = json['study_design']['study_end_date'].blank? ? nil : Date.parse(json['study_design']['study_end_date']).strftime("%d.%m.%Y")
        # pp 'after: study_start_date:'+ json['study_design']['study_start_date'].inspect
        # pp 'after: study_end_date:'+ json['study_design']['study_end_date'].inspect
      end


    puts ' ----------------------------------------- '
    puts 'step 8:  update boolean type properties...'

      StudyhubResource::BOOLEAN_ATTRIBUTES_HASH['resource'].each do |attr|
        if json.key?(attr)
          # pp json[attr].inspect
          json[attr] = case json[attr]
                       when 'Yes'
                         true
                       when 'No'
                         false
          end
        end
      end

      if sr.is_studytype? && json['study_design'].key?('study_masking')
        # pp json['study_design']['study_masking'].inspect
        json['study_design']['study_masking'] = case json['study_design']['study_masking']
                                                when 'Yes'
                                                  true
                                                when 'No'
                                                  false
        end
      end


    puts ' ----------------------------------------- '
    puts 'step 9:  update Integer and Float type properties...'

      if sr.is_studytype?

        StudyhubResource::INTEGER_ATTRIBUTES.each do |attr|
          if json['study_design'].key? attr
            # pp attr
            json['study_design'][attr] = if json['study_design'][attr].blank?
                                           nil
                                         else
                                           Integer(json['study_design'][attr])
                                         end

            # pp json['study_design'][attr]
          end
        end

        StudyhubResource::FLOAT_ATTRIBUTES.each do |attr|
          if json['study_design'].key? attr
            # pp attr
            json['study_design'][attr] = if json['study_design'][attr].blank?
                                           nil
                                         else
                                             Float(json['study_design'][attr])
                                         end
            # pp json['study_design'][attr]
          end
        end
        json['study_design'].delete('study_target_follow-up_duration') if json['study_design']['study_primary_design'] == "Interventional"
      end

      puts ' ----------------------------------------- '
      puts 'step 10: update the label texts for language...'

      json['resource_titles'].each do |title|
        # pp title['title_language']
        title['title_language']= update_language_text(title['title_language'])
      end

      json['resource_acronyms'].each do |acronym|
        # pp acronym['acronym_language']
        acronym['acronym_language'] = update_language_text(acronym['acronym_language'])
      end

      json['resource_descriptions'].each do |description|
        # pp description['description_language']
        description['description_language'] = update_language_text(description['description_language'])
      end


      puts ' ----------------------------------------- '
      puts 'step 11:  update Integer and Float type properties...'

      if sr.is_studytype?
        json['study_design']['study_status_when_intervention'] = 'follow-up ongoing' if json['study_design']['study_status_when_intervention'] == 'Follow-up ongoing'
      end


      sr.update_column(:resource_json, json)

    end

  end



  task(update_attribute_types: :environment) do

    StudyhubResource.all.each do |sr|
      puts 'Update attribute types ... '
      puts 'id='+sr.id.to_s+'('+sr.studyhub_resource_type.title+'):'
      json = sr.resource_json

      unless json['resource'].key?('resource_keywords')
        puts 'Convert resource keywords ...'
        json['resource']['resource_keywords'] = []
        resource_keyword = {}
        resource_keyword['resource_keywords_label'] = json['resource']['resource_keywords_label']
        resource_keyword['resource_keywords_label_code'] = json['resource']['resource_keywords_label_code']
        json['resource']['resource_keywords'] << resource_keyword
        json['resource'].delete('resource_keywords_label')
        json['resource'].delete('resource_keywords_label_code')
      end

      json['roles'].each do |role|
        unless role.key?('role_name_identifiers')
          puts 'Convert role name identifiers ...'
          role['role_name_identifiers'] =[]
          hash = {}
          hash['role_name_identifier'] = role['role_name_identifier']
          hash['role_name_identifier_scheme'] = role['role_name_identifier_scheme']
          role['role_name_identifiers'] << hash
          role.delete('role_name_identifier')
          role.delete('role_name_identifier_scheme')
        end

        unless role.key?('role_affiliation_identifiers')
          puts 'Convert role affiliation identifiers ...'
          role['role_affiliation_identifiers'] =[]
          hash = {}
          hash['role_affiliation_identifier'] = role['role_affiliation_identifier']
          hash['role_affiliation_identifier_scheme'] = role['role_affiliation_identifier_scheme']
          role['role_affiliation_identifiers'] << hash
          role.delete('role_affiliation_identifier')
          role.delete('role_affiliation_identifier_scheme')
        end
      end

      sd = json['study_design']

      unless sd.nil?
        if sd.key?('study_conditions_classification')
          puts 'Convert resource study conditions ...'
          study_conditions = sd['study_conditions']
          study_conditions_classification= sd['study_conditions_classification']
          study_conditions_classification_code = sd['study_conditions_classification_code']

          sd.delete('study_conditions')
          sd.delete('study_conditions_classification')
          sd.delete('study_conditions_classification_code')

          sd['study_conditions']=[]
          hash = {}
          hash['study_conditions'] = study_conditions
          hash['study_conditions_classification'] = study_conditions_classification
          hash['study_conditions_classification_code'] = study_conditions_classification_code
          sd['study_conditions']  << hash
        end


        unless sd.key?('study_outcomes')
          puts 'Convert resource study outcomes ...'
          sd['study_outcomes'] = []

          hash = {}
          hash['study_outcome_type'] = sd['study_outcome_type']
          hash['study_outcome_title'] = sd['study_outcome_title']
          hash['study_outcome_time_frame'] = sd['study_outcome_time_frame']
          hash['study_outcome_description'] = sd['study_outcome_description']
          sd['study_outcomes'] << hash

          sd.delete('study_outcome_type')
          sd.delete('study_outcome_title')
          sd.delete('study_outcome_time_frame')
          sd.delete('study_outcome_description')
        end

        unless sd.key?('interventional_study_design_arms')
          puts 'Convert interventional study design arms ...'
          sd['interventional_study_design_arms'] = []
          hash = {}

          hash['study_arm_group_type'] = sd['study_arm_group_type']
          hash['study_arm_group_label'] = sd['study_arm_group_label']
          hash['study_arm_group_description'] = sd['study_arm_group_description']
          sd['interventional_study_design_arms'] << hash

          sd.delete('study_arm_group_type')
          sd.delete('study_arm_group_label')
          sd.delete('study_arm_group_description')
        end

        unless sd.key?('interventional_study_design_interventions')
          puts 'Convert interventional study design interventions ...'
          sd['interventional_study_design_interventions'] = []
          hash = {}

          hash['study_intervention_name'] = sd['study_intervention_name']
          hash['study_intervention_type'] = sd['study_intervention_type']
          hash['study_intervention_description'] = sd['study_intervention_description']
          hash['study_intervention_arm_group_label'] = sd['study_intervention_arm_group_label']
          sd['interventional_study_design_interventions'] << hash

          sd.delete('study_intervention_name')
          sd.delete('study_intervention_type')
          sd.delete('study_intervention_description')
          sd.delete('study_intervention_arm_group_label')
        end

      end

      sr.update_column(:resource_json, json)
      # puts JSON.pretty_generate(json)
    end
  end
end

def update_language_text(language)
  case language[0, 2]
  when 'EN'
    language = 'EN (English)'
  when 'DE'
    language = 'DE (German)'
  when 'ES'
    language = 'ES (Spanish)'
  when 'FR'
    language = 'FR (French)'
  end
  language
end