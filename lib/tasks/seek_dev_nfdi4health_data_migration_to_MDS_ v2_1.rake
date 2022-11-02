require 'json'

namespace :seek_dev_nfdi4health_update_to_MDS_v2_1 do


  task(update_sample_controlled_vocab_terms: :environment) do

    # add_new_values_to_study_data_source
    scv= SampleControlledVocab.where(title: 'NFDI4Health Study Data Source').first
    scv.sample_controlled_vocab_terms << SampleControlledVocabTerm.find_or_create_by(label: 'Biological samples')
    scv.sample_controlled_vocab_terms << SampleControlledVocabTerm.find_or_create_by(label: 'Imaging data')
    scv.sample_controlled_vocab_terms << SampleControlledVocabTerm.find_or_create_by(label: 'Omics technology')

    #update_allowed_values_of_relation_type
    scv= SampleControlledVocab.where(title:  'NFDI4Health ID Relation Type').first
    scv.sample_controlled_vocab_terms.each do |term|
      term.update_attributes label: 'A '+term.label+' B' unless term.label.start_with? 'A'
    end

    #update_allowed_values_of_study_data_sharing_plan_generally
    scv= SampleControlledVocab.where(title:  'NFDI4Health Study Data Sharing Plan Generally').first
    scv.sample_controlled_vocab_terms.each do |term|
      term.update_attributes label: term.label.chomp('.')
    end

    #rename_contact_person_to_contact
    scv= SampleControlledVocab.where(title:  'NFDI4Health Role Type').first
    scv.sample_controlled_vocab_terms.where(label: 'Contact person').first.update_attributes label: 'Contact'

    #remove_allowed_values_of_study_subject
    scv = SampleControlledVocab.where(title:  'NFDI4Health Study Subject').first
    scv.sample_controlled_vocab_terms = scv.sample_controlled_vocab_terms.select {|term| ['Person', 'Animal', 'Other', 'Unknown'].include? term.label }

    #update_allowed_values_of_study_biospecimen_retention
    scv = SampleControlledVocab.where(title:  'NFDI4Health Study Biospecimen Retention').first
    scv.sample_controlled_vocab_terms.where(label: ' Samples without DNA').first.update_attributes label: 'Samples without DNA'

    scv.save!
  end


  task(data_migration_to_MDS_2_1: :environment) do

    # the changes for all resources
    StudyhubResource.all.each do |sr|

      json = sr.resource_json
      new_json = {}

      # 1.['ids'] + ['ids_alternative'] + ['ids_nfdi4health']

      new_json['ids'] = []
      new_json['ids_alternative'] = []
      new_json['ids_nfdi4health'] = []

      json['ids'].each do |id|
        if (id['id_relation_type'] == 'has alternate ID')
          new_alt_id = {}
          new_alt_id['identifier'] = id['id_identifier']
          new_alt_id['type'] = id['id_type']
          new_json['ids_alternative'] << new_alt_id
        elsif id['id_type'] == 'NFDI4Health'
          nfdi_id = {}
          nfdi_id['identifier'] = id['id_identifier']
          nfdi_id['relation_type'] = id['id_relation_type']
          nfdi_id['relation_type'] = id['id_relation_type'].blank? ? '' : 'A '+id['id_relation_type']+ ' B'
          new_json['ids_nfdi4health'] << nfdi_id
        else
          new_id = {}
          new_id['identifier'] = id['id_identifier']
          new_id['type'] = id['id_type']
          new_id['date'] = id['id_date']
          new_id['relation_type'] = id['id_relation_type'].blank? ? '' : 'A '+id['id_relation_type']+ ' B'
          new_id['resource_type_general'] = id['id_resource_type_general']
          new_json['ids'] << new_id
        end
      end


      # 2.['roles']
      new_json['roles'] = []
      json['roles'].each do |role|

        new_role = {}

        new_role['role_email'] = role['role_email']
        new_role['role_phone'] = role['role_phone']


        case role['role_name_type']
        when 'Organisational'
          new_role['role_name_type'] = 'Organisational'

          new_role['role_name_organisational_group'] = {}
          new_role['role_name_organisational_group']['type'] = role['role_type'].chomp(' person')
          new_role['role_name_organisational_group']['role_name_organisational_group_name'] = role['role_name_organisational']
          new_role['role_name_organisational_group']['role_name_organisational_group_type_funding_id'] = ''

        when 'Personal'
          new_role['role_name_type'] = 'Personal'
          new_role['role_name_personal'] = {}
          new_role['role_name_personal']['type'] = role['role_type'].chomp(' person')
          new_role['role_name_personal']['role_name_personal_given_name'] = role['role_name_personal_given_name']
          new_role['role_name_personal']['role_name_personal_family_name'] = role['role_name_personal_family_name']
          new_role['role_name_personal']['role_name_personal_title'] = role['role_name_personal_title']

          new_role['role_name_personal']['role_name_identifiers'] = []
          role['role_name_identifiers'].each do |id|
            new_id = {}
            new_id['identifier'] = id['role_name_identifier']
            new_id['scheme'] = id['role_name_identifier_scheme']
            new_role['role_name_personal']['role_name_identifiers'] << new_id
          end

        end

        new_role['role_affiliations'] = []
        role_affiliations = {}
        role_affiliations['role_affiliation_name'] = role['role_affiliation_name']
        role_affiliations['role_affiliation_address'] = role['role_affiliation_address']
        role_affiliations['role_affiliation_web_page'] = role['role_affiliation_web_page']
        role_affiliations['role_affiliation_identifiers'] = []

        role['role_affiliation_identifiers'].each do |id|
          new_id = {}
          new_id['identifier'] = id['role_affiliation_identifier']
          new_id['scheme'] = id['role_affiliation_identifier_scheme']
          role_affiliations['role_affiliation_identifiers'] << new_id
        end

        new_role['role_affiliations'] << role_affiliations

        new_json['roles'] << new_role
      end

      # 3.['provenance']
      new_json['provenance'] = {}
      new_json['provenance']['data_source'] = json['provenance']['data_source']
      new_json['provenance']['verification_date'] = ''
      new_json['provenance']['verification_date_user'] = ''
      new_json['provenance']['resource_first_submitted_date'] = ''
      new_json['provenance']['resource_first_submitted_user'] = ''
      new_json['provenance']['resource_first_posted_date'] = ''
      new_json['provenance']['resource_first_posted_user'] = ''
      new_json['provenance']['last_update_submitted_date'] = ''
      new_json['provenance']['last_update_submitted_user'] = ''
      new_json['provenance']['last_update_posted_date'] = ''
      new_json['provenance']['last_update_posted_user'] = ''
      new_json['provenance']['resource_version'] = ''

      # 4. ['resource_titles']
      new_json['resource_titles'] = []
      json['resource_titles'].each do |title|
        new_title = {}
        new_title['text'] = title['title']
        new_title['language'] = title['title_language']
        new_json['resource_titles'] << new_title
      end

      # 5. ['resource_acronyms']
      new_json['resource_acronyms'] = []
      json['resource_acronyms'].each do |acronym|
        new_acronyms = {}
        new_acronyms['text'] = acronym['acronym']
        new_acronyms['language'] = acronym['acronym_language']
        new_json['resource_acronyms'] << new_acronyms
      end


      # 6. ['resource_languages']
      new_json['resource_languages'] = json['resource_language']


      # 7. ['resource_web_page']
      new_json['resource_web_page'] = json['resource_web_page']


      # 8.  ['resource_description_english']
      new_json['resource_description_english'] = {}
      json['resource_descriptions'].each do |desc|
        if desc['description_language'] == 'EN (English)'
          new_json['resource_description_english']['text'] = desc['description']
          new_json['resource_description_english']['language'] = 'EN (English)'
        end
      end

      if new_json['resource_description_english'].blank?
        new_json['resource_description_english']['text'] = ''
        new_json['resource_description_english']['language'] = ''
      end

      # 9.  ['resource_descriptions_non_english']
      json['resource_descriptions'].each do |desc|
        non_english_descrs = []

        unless desc['description_language'] == 'EN (English)'
          new_desc ={}
          new_desc['text'] = desc['description']
          new_desc['language'] = desc['description_language']
          non_english_descrs << new_desc
        end
        if non_english_descrs.blank?
          non_english_descrs[0] = {}
          non_english_descrs[0]['text'] = ''
          non_english_descrs[0]['language'] = ''
        end
        new_json['resource_descriptions_non_english'] = non_english_descrs
      end


      #10. ['resource_classification']
      new_json['resource_classification'] = {}
      new_json['resource_classification']['resource_type'] = sr.studyhub_resource_type.title

      #11. ['resource_keywords']
      new_json['resource_keywords'] = json['resource_keywords']


      ###################non_study#####################

      unless sr.is_studytype?

        # 10.1. ['resource_classification']
        new_json['resource_classification']['resource_type_general'] = json['resource_type_general']

        # 11. ['resource_non_study_details']
        new_json['resource_non_study_details'] = {}
        new_json['resource_non_study_details']['resource_version'] = json['resource_version']
        new_json['resource_non_study_details']['resource_format']  = json['resource_format']
        resource_use_rights = {}
        resource_use_rights['resource_use_rights_label'] = json['resource_use_rights_label']

        if ['CC BY 4.0 (Creative Commons Attribution 4.0 International)',
            'CC BY-NC 4.0 (Creative Commons Attribution Non Commercial 4.0 International)',
            'CC BY-SA 4.0 (Creative Commons Attribution Share Alike 4.0 International)',
            'CC BY-NC-SA 4.0 (Creative Commons Attribution Non Commercial Share Alike 4.0 International)'].include? json['resource_use_rights_label']
          resource_use_rights['resource_use_rights_confirmations'] = {}
          resource_use_rights['resource_use_rights_confirmations']['resource_use_rights_authors_confirmation_1'] = json['resource_use_rights_authors_confirmation_1']
          resource_use_rights['resource_use_rights_confirmations']['resource_use_rights_authors_confirmation_2'] = json['resource_use_rights_authors_confirmation_2']
          resource_use_rights['resource_use_rights_confirmations']['resource_use_rights_authors_confirmation_3'] = json['resource_use_rights_authors_confirmation_3']
          resource_use_rights['resource_use_rights_confirmations']['resource_use_rights_support_by_licencing'] = json['resource_use_rights_support_by_licencing']
        end

        resource_use_rights['resource_use_rights_description'] = json['resource_use_rights_description']
        new_json['resource_non_study_details']['resource_use_rights']  = resource_use_rights
      end

      # 12. ['study_design']
      if sr.is_studytype?

        sd = json['study_design']

        new_json['study_design']={}

        # ['study_design']['study_primary_design']
        new_json['study_design']['study_primary_design'] = sd['study_primary_design']

        # ['study_design']['study_type']
        new_json['study_design']['study_type'] = [sd['study_type']]

        # ['study_design']['study_conditions']
        new_json['study_design']['study_conditions'] = []
        sd['study_conditions'].each do |con|
          new_condition ={}
          new_condition['study_conditions_label'] = con['study_conditions']
          new_condition['study_conditions_classification'] = con['study_conditions_classification']
          new_condition['study_conditions_classification_code'] = con['study_conditions_classification_code']
          new_json['study_design']['study_conditions'] << new_condition
        end

        # ['study_design']['study_groups_of_diseases']
        new_json['study_design']['study_groups_of_diseases'] = {}
        new_json['study_design']['study_groups_of_diseases']['study_groups_of_diseases_generally']=['Unknown']
        new_json['study_design']['study_groups_of_diseases']['study_groups_of_diseases_prevalent_outcomes']=''
        new_json['study_design']['study_groups_of_diseases']['study_groups_of_diseases_incident_outcomes']=''

        # ['study_design']['study_ethics_committee_approval']
        new_json['study_design']['study_ethics_committee_approval'] = if sd['study_ethics_commitee_approval'].blank?
                                                                        ''
                                                                      else
                                                                        sd['study_ethics_commitee_approval']
                                                                      end


        #todo ['study_design']['study_status'], https://github.com/nfdi4health/metadataschema/issues/206
        new_json['study_design']['study_status'] = sd['study_status']

        if sr.is_interventional_study?
          if (sd['study_status'].start_with? 'Ongoing') || (sd['study_status'].start_with? 'At')
            new_json['study_design']['study_status_when_intervention'] = sd['study_status_when_intervention']
          end
        end



        if (sd['study_status'].start_with? 'Suspended') || (sd['study_status'].start_with? 'Terminated')
          new_json['study_design']['study_status_halted_stage'] = sd['study_status_halted_stage']
          new_json['study_design']['study_status_halted_reason'] = sd['study_status_halted_reason']
        end

        new_json['study_design']['study_status_enrolling_by_invitation'] = sd['study_status_enrolling_by_invitation']



        # ['study_design']['study_recruitment_status_register']
        new_json['study_design']['study_recruitment_status_register'] = if sd['study_recruitment_status_register'].blank?
                                                                          ''
                                                                        else
                                                                          sd['study_recruitment_status_register']
                                                                        end


        # ['study_design']['study_start_date']
        new_json['study_design']['study_start_date'] = if sd['study_start_date'].blank?
                                                         ''
                                                       else
                                                         sd['study_start_date']
                                                       end


        # ['study_design']['study_end_date']
        new_json['study_design']['study_end_date'] = if sd['study_end_date'].blank?
                                                       ''
                                                     else
                                                       sd['study_end_date']
                                                     end


        # ['study_design']['study_countries']
        new_json['study_design']['study_countries'] = if sd['study_country'].blank?
                                                        []
                                                      else
                                                        sd['study_country']
                                                      end


        # ['study_design']['study_region']
        new_json['study_design']['study_region'] = if sd['study_region'].blank?
                                                     ''
                                                   else
                                                     sd['study_region']
                                                   end



        # ['study_design']['study_centers']
        new_json['study_design']['study_centers'] = if sd['study_centers'].blank?
                                                      ''
                                                    else
                                                      sd['study_centers']
                                                    end


        # ['study_design']['study_centers_number']
        new_json['study_design']['study_centers_number'] = if sd['study_centers_number'].blank?
                                                             nil
                                                           else
                                                             sd['study_centers_number']
                                                           end



        # ['study_design']['study_subject']
        new_json['study_design']['study_subject'] = if sd['study_subject'].blank?
                                                      ''
                                                    else
                                                      if %w[Person Animal Other Unknown].include? sd['study_subject']
                                                        sd['study_subject']
                                                      else
                                                        'Other'
                                                      end
                                                    end

        #['study_design']['study_sampling']
        new_json['study_design']['study_sampling']={}

        if sd['study_sampling'].start_with?('Probability')
          new_json['study_design']['study_sampling']['study_sampling_method'] = 'Probability'
          unless sd['study_sampling'] == 'Probability'
            new_json['study_design']['study_sampling']['study_sampling_method_probability'] = sd['study_sampling'].partition("(").last.partition(")").first
          end

        elsif sd['study_sampling'].start_with?('Non-probability')
          new_json['study_design']['study_sampling']['study_sampling_method'] = 'Non-probability'
          unless sd['study_sampling'] == 'Non-probability'
            new_json['study_design']['study_sampling']['study_sampling_method_non_probability'] = sd['study_sampling'].partition("(").last.partition(")").first
          end

        else
          new_json['study_design']['study_sampling']['study_sampling_method'] = if sd['study_sampling'].blank?
                                                                                  ''
                                                                                else
                                                                                  sd['study_sampling']
                                                                                end
        end


        #['study_design']['study_data_source']
        biological_samples = ['Blood', 'Buccal cells', 'Cord blood', 'DNA', 'Faeces', 'Hair', 'Immortalized cell lines',
                              'Isolated pathogen', 'Nail', 'Plasma', 'RNA', 'Saliva', 'Serum', 'Tissue (frozen)', 'Tissue (FFPE)', 'Urine', 'Other biological samples']
        imaging_data = ['Imaging data (ultrasound)','Imaging data (MRI)','Imaging data (MRI, radiography)','Imaging data (CT)','Other imaging data']
        proteomics = ['Genomics','Metabolomics','Transcriptomics','Proteomics','Other omics technology']
        new_json['study_design']['study_data_source'] = {}
        new_json['study_design']['study_data_source']['study_data_sources_general'] = []
        new_json['study_design']['study_data_source']['study_data_sources_biosamples'] = []
        new_json['study_design']['study_data_source']['study_data_sources_imaging'] = []
        new_json['study_design']['study_data_source']['study_data_sources_omics'] = []
        new_json['study_design']['study_data_source']['study_data_source_description'] = sd['study_data_source_description']

        old_ds = sd['study_data_source'].map{|x| SampleControlledVocabTerm.find(x).label}
        study_data_sources_general = []
        old_ds.each do |ds|
          ds_id = SampleControlledVocabTerm.find_by(label: ds).id
          if biological_samples.include? ds
            study_data_sources_general << SampleControlledVocabTerm.find_by(label: 'Biological samples').id
            new_json['study_design']['study_data_source']['study_data_sources_biosamples'] << ds_id
          elsif imaging_data.include? ds
            study_data_sources_general << SampleControlledVocabTerm.find_by(label: 'Imaging data').id
            new_json['study_design']['study_data_source']['study_data_sources_imaging'] << ds_id
          elsif proteomics.include? ds
            study_data_sources_general << SampleControlledVocabTerm.find_by(label: 'Omics technology').id
            new_json['study_design']['study_data_source']['study_data_sources_omics'] << ds_id
          else
            study_data_sources_general << ds_id
          end
        end
        new_json['study_design']['study_data_source']['study_data_sources_general']= study_data_sources_general.uniq

        #['study_design']['study_primary_purpose']
        new_json['study_design']['study_primary_purpose'] = if sr.is_interventional_study?
                                                              sd['interventional_study_design']['study_primary_purpose']
                                                            else
                                                              ''
                                                            end

        #['study_design']['study_eligibility_criteria']
        new_json['study_design']['study_eligibility_criteria']={}
        study_eligibility_age_min = {}
        study_eligibility_age_max = {}

        new_json['study_design']['study_eligibility_criteria']['study_eligibility_genders'] = sd['study_eligibility_gender']
        new_json['study_design']['study_eligibility_criteria']['study_eligibility_inclusion_criteria'] = sd['study_eligibility_inclusion_criteria']
        new_json['study_design']['study_eligibility_criteria']['study_eligibility_exclusion_criteria'] = sd['study_eligibility_exclusion_criteria']

        study_eligibility_age_min['number'] = sd['study_eligibility_age_min']
        #todo check if 'time_unit' is a new item in 2.1
        study_eligibility_age_min['time_unit']=''

        study_eligibility_age_max['number']= sd['study_eligibility_age_max']
        #todo check if 'time_unit' is a new item in 2.1
        study_eligibility_age_max['time_unit']=''

        new_json['study_design']['study_eligibility_criteria']['study_eligibility_age_min'] = study_eligibility_age_min
        new_json['study_design']['study_eligibility_criteria']['study_eligibility_age_max'] = study_eligibility_age_max

        #['study_design']['study_population']
        new_json['study_design']['study_population'] = sd['study_population']

        #['study_design']['study_target_sample_size']
        new_json['study_design']['study_target_sample_size'] = sd['study_target_sample_size']


        #['study_design']['study_obtained_sample_size']
        new_json['study_design']['study_obtained_sample_size'] = sd['study_obtained_sample_size']

        #['study_design']['study_age_min_examined']
        new_json['study_design']['study_age_min_examined'] = {}
        new_json['study_design']['study_age_min_examined']['number'] = sd['study_age_min_examined']
        #todo check if 'time_unit' is a new item in 2.1
        new_json['study_design']['study_age_min_examined']['time_unit'] = ''

        #['study_design']['study_age_max_examined']
        new_json['study_design']['study_age_max_examined']= {}
        new_json['study_design']['study_age_max_examined']['number'] = sd['study_age_max_examined']
        #todo check if 'time_unit' is a new item in 2.1
        new_json['study_design']['study_age_max_examined']['time_unit'] = ''


        # ['study_design']['study_hypothesis']
        new_json['study_design']['study_hypothesis'] = sd['study_hypothesis']

        #['study_design']['study_arms_groups']
        new_json['study_design']['study_arms_groups'] = if (sr.is_interventional_study? && !sd['interventional_study_design']['interventional_study_design_arms'].blank?)
                                                          sd['interventional_study_design']['interventional_study_design_arms']
                                                        else
                                                          []
                                                        end

        #['study_design']['study_interventions']
        new_json['study_design']['study_interventions'] = if (sr.is_interventional_study? && !sd['interventional_study_design']['interventional_study_design_interventions'].blank?)
                                                            study_interventions = []
                                                            sd['interventional_study_design']['interventional_study_design_interventions']&.each do |old|
                                                              new = {}
                                                              new['study_intervention_arms_groups_label'] = old['study_intervention_arm_group_label']
                                                              new['study_intervention_name'] = old['study_intervention_name']
                                                              new['study_intervention_type'] = old['study_intervention_type']
                                                              new['study_intervention_description'] = old['study_intervention_description']
                                                              study_interventions << new
                                                            end
                                                            study_interventions
                                                          else
                                                            []
                                                          end


        #['study_design']['study_outcomes']
        new_json['study_design']['study_outcomes']  = if !sd['study_outcomes'].blank?
                                                        sd['study_outcomes']
                                                      else
                                                        []
                                                      end



        #['study_design']['study_design_comment']
        new_json['study_design']['study_design_comment'] = sd['study_design_comment']



        #['study_design']['study_data_sharing_plan']
        new_json['study_design']['study_data_sharing_plan'] = {}
        new_json['study_design']['study_data_sharing_plan']['study_data_sharing_plan_generally'] = sd['study_data_sharing_plan_generally'].chomp('.')
        new_json['study_design']['study_data_sharing_plan']['study_data_sharing_plan_description'] = sd['study_data_sharing_plan_description']
        new_json['study_design']['study_data_sharing_plan']['study_data_sharing_plan_datashield'] = ''
        new_json['study_design']['study_data_sharing_plan']['study_data_sharing_plan_url'] = sd['study_data_sharing_plan_url']


        if sd['study_data_sharing_plan_generally'] == 'Yes, there is a plan to make data available.'
          new_json['study_design']['study_data_sharing_plan']['study_data_sharing_plan_supporting_information'] = sd['study_data_sharing_plan_supporting_information']
          new_json['study_design']['study_data_sharing_plan']['study_data_sharing_plan_time_frame'] = sd['study_data_sharing_plan_time_frame']
          new_json['study_design']['study_data_sharing_plan']['study_data_sharing_plan_access_criteria'] = sd['study_data_sharing_plan_access_criteria']
        end


        #['study_design']['study_design_interventional']
        if sr.is_interventional_study?
          new_json['study_design']['study_design_interventional'] = {}
          new_json['study_design']['study_design_interventional']['study_phase'] = sd['interventional_study_design']['study_phase']
          new_json['study_design']['study_design_interventional']['study_masking'] = {}
          #todo check if the mapping is ok
          new_json['study_design']['study_design_interventional']['study_masking']['study_masking_general'] = sd['interventional_study_design']['study_masking']
          new_json['study_design']['study_design_interventional']['study_masking']['study_masking_roles'] = sd['interventional_study_design']['study_masking_roles'] if sd['interventional_study_design']['study_masking']
          new_json['study_design']['study_design_interventional']['study_masking']['study_masking_description'] = sd['interventional_study_design']['study_masking_description'] if sd['interventional_study_design']['study_masking']
          new_json['study_design']['study_design_interventional']['study_allocation'] = sd['interventional_study_design']['study_allocation']
          new_json['study_design']['study_design_interventional']['study_off_label_use'] = sd['interventional_study_design']['study_off_label_use']
        end

        #['study_design']['study_design_non_interventional']
        if sr.is_non_interventional_study?
          new_json['study_design']['study_design_non_interventional'] = {}
          new_json['study_design']['study_design_non_interventional']['study_time_perspectives'] = sd['non_interventional_study_design']['study_time_perspective']
          new_json['study_design']['study_design_non_interventional']['study_target_followup_duration'] = sd['non_interventional_study_design']['study_target_follow-up_duration']
          new_json['study_design']['study_design_non_interventional']['study_biospecimen_retention'] = sd['non_interventional_study_design']['study_biospecimen_retention']
          new_json['study_design']['study_design_non_interventional']['study_biospecimen_description'] = sd['non_interventional_study_design']['study_biospecomen_description']
        end
      end


      # at the very end to print new_json and update the resource_json

      # unless new_json.blank?
      #   pp "________________: "+sr.id.to_s+" _________________"
      #   # if sr.is_interventional_study?
      #   pp '____________new_json___________________'
      #   pp new_json
      #   # end
      # end

      sr.update_column(:resource_json, new_json)
    end
  end

end

