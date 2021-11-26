require 'json'
namespace :seek_dev_nfdi4health do

  task(update_attribute_types: :environment) do

    StudyhubResource.all.each do |sr|
      puts 'Update attribute types ... '
      puts 'id='+sr.id.to_s+'('+sr.studyhub_resource_type.title+'):'
      json = sr.resource_json

      unless json['resource'].has_key?('resource_keywords')
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
        unless role.has_key?('role_name_identifiers')
          puts 'Convert role name identifiers ...'
          role['role_name_identifiers'] =[]
          hash = {}
          hash['role_name_identifier'] = role['role_name_identifier']
          hash['role_name_identifier_scheme'] = role['role_name_identifier_scheme']
          role['role_name_identifiers'] << hash
          role.delete('role_name_identifier')
          role.delete('role_name_identifier_scheme')
        end

        unless role.has_key?('role_affiliation_identifiers')
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
        if sd.has_key?('study_conditions_classification')
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


        unless sd.has_key?('study_outcomes')
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

        unless sd.has_key?('interventional_study_design_arms')
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

        unless sd.has_key?('interventional_study_design_interventions')
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

