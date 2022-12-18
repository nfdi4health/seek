require 'json'

namespace :seek_dev_nfdi4health_update_to_MDS_v2_1 do


  task(update_sample_controlled_vocab_terms: :environment) do

    # add_new_values_to_study_data_source
    scv = SampleControlledVocab.where(title: 'NFDI4Health Study Data Source').first
    scv.sample_controlled_vocab_terms << SampleControlledVocabTerm.find_or_create_by(label: 'Biological samples')
    scv.sample_controlled_vocab_terms << SampleControlledVocabTerm.find_or_create_by(label: 'Imaging data')
    scv.sample_controlled_vocab_terms << SampleControlledVocabTerm.find_or_create_by(label: 'Omics technology')

    #update_allowed_values_of_relation_type
    scv = SampleControlledVocab.where(title:  'NFDI4Health ID Relation Type').first
    scv.sample_controlled_vocab_terms.each do |term|
      term.update_attributes label: 'A ' + term.label + ' B' unless term.label.start_with? 'A'
    end

    #update_allowed_values_of_study_data_sharing_plan_generally
    scv = SampleControlledVocab.where(title:  'NFDI4Health Study Data Sharing Plan Generally').first
    scv.sample_controlled_vocab_terms.each do |term|
      term.update_attributes label: term.label.chomp('.')
    end

    #rename_contact_person_to_contact
    scv = SampleControlledVocab.where(title:  'NFDI4Health Role Type').first
    scv.sample_controlled_vocab_terms.where(label: 'Contact person').first.update_attributes label: 'Contact'

    #remove_allowed_values_of_study_subject
    scv = SampleControlledVocab.where(title:  'NFDI4Health Study Subject').first
    scv.sample_controlled_vocab_terms = scv.sample_controlled_vocab_terms.select {|term|
 ['Person', 'Animal', 'Other', 'Unknown'].include? term.label }

    #update_allowed_values_of_study_biospecimen_retention
    scv = SampleControlledVocab.where(title:  'NFDI4Health Study Biospecimen Retention').first
    scv.sample_controlled_vocab_terms.where(label: ' Samples without DNA').first.update_attributes label: 'Samples without DNA'


    #update_study_ethics_committee_approval
    scv = SampleControlledVocab.where(title:  'NFDI4Health Study Ethics Commitee Approval').first
    scv.sample_controlled_vocab_terms.where(label: 'Request submitted, approval pending').first.update_attributes label: 'Request for approval submitted, approval pending'
    scv.sample_controlled_vocab_terms.where(label: 'Request submitted, approval granted').first.update_attributes label: 'Request for approval submitted, approval granted'
    scv.sample_controlled_vocab_terms.where(label: 'Request submitted, exempt granted').first.update_attributes label: 'Request for approval submitted, exempt granted'
    scv.sample_controlled_vocab_terms.where(label: 'Request submitted, approval denied').first.update_attributes label: 'Request for approval submitted, approval denied'
    scv.sample_controlled_vocab_terms.where(label: 'Unknown').first.update_attributes label: 'Unknown status of request approval'

    scv = SampleControlledVocab.where(title:  'NFDI4Health ID Type').first
    scv.sample_controlled_vocab_terms.where(label: 'NCT(ClinicalTrials.gov)').first.update_attributes label: 'NCT (ClinicalTrials.gov)'

    #update_study_outcome_type
    scv = SampleControlledVocab.where(title: 'NFDI4Health Study Outcome Type').first
    scv.sample_controlled_vocab_terms.where(label: ' Secondary').first.update_attributes label: 'Secondary'

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
          new_alt_id['type'] = case id['id_type']
                               when 'URL'
                                 'Other'
                               when 'NCT(ClinicalTrials.gov)'
                                 'NCT (ClinicalTrials.gov)'
                               else
                                 id['id_type']
                               end
          new_json['ids_alternative'] << new_alt_id
        elsif id['id_type'] == 'NFDI4Health'
          nfdi_id = {}
          nfdi_id['identifier'] = id['id_identifier']
          nfdi_id['relation_type'] = id['id_relation_type']
          nfdi_id['relation_type'] = id['id_relation_type'].blank? ? '' : 'A ' + id['id_relation_type'] + ' B'
          new_json['ids_nfdi4health'] << nfdi_id
        else
          new_id = {}
          new_id['identifier'] = id['id_identifier']
          new_id['type'] = id['id_type']
          new_id['date'] = id['id_date'] unless id['id_date'].blank?
          new_id['relation_type'] = id['id_relation_type'].blank? ? '' : 'A ' + id['id_relation_type'] + ' B'
          new_id['resource_type_general'] = id['id_resource_type_general'] unless id['id_resource_type_general'].blank?
          new_json['ids'] << new_id
        end
      end
      new_json.delete('ids_alternative') if new_json['ids_alternative'].blank?
      new_json.delete('ids_nfdi4health') if new_json['ids_nfdi4health'].blank?
      new_json.delete('ids') if new_json['ids'].blank?



      # 2.['roles']
      new_json['roles'] = []
      json['roles'].each do |role|

        new_role = {}

        new_role['role_email'] = role['role_email'] unless role['role_email'].blank?
        new_role['role_phone'] = role['role_phone'] unless role['role_phone'].blank?


        case role['role_name_type']
        when 'Organisational'
          new_role['role_name_type'] = 'Organisational'

          new_role['role_name_organisational_group'] = {}
          new_role['role_name_organisational_group']['type'] = role['role_type'].chomp('person')
          new_role['role_name_organisational_group']['role_name_organisational_group_name'] =
            role['role_name_organisational']

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
          if new_role['role_name_personal']['role_name_identifiers'].blank?
            new_role['role_name_personal'].delete('role_name_identifiers')
          end
        end

        new_role['role_affiliations'] = []
        role_affiliations = {}
        role_affiliations['role_affiliation_name'] = role['role_affiliation_name']
        unless role['role_affiliation_address'].blank?
          role_affiliations['role_affiliation_address'] = role['role_affiliation_address']
        end
        unless role['role_affiliation_web_page'].blank?
          role_affiliations['role_affiliation_web_page'] = role['role_affiliation_web_page']
        end
        role_affiliations['role_affiliation_identifiers'] = []

        role['role_affiliation_identifiers'].each do |id|
          new_id = {}
          new_id['identifier'] = id['role_affiliation_identifier']
          new_id['scheme'] = id['role_affiliation_identifier_scheme']
          role_affiliations['role_affiliation_identifiers'] << new_id
        end
        if role_affiliations['role_affiliation_identifiers'].blank?
          role_affiliations.delete('role_affiliation_identifiers')
        end

        new_role['role_affiliations'] << role_affiliations

        new_role.delete('role_affiliations') if new_role['role_affiliations'].blank?

        new_json['roles'] << new_role
      end

      # 3.['provenance']
      new_json['provenance'] = {}
      new_json['provenance']['data_source'] = json['provenance']['data_source']

      # 4. ['resource_titles']
      new_json['resource_titles'] = []
      json['resource_titles'].each do |title|
        new_title = {}
        new_title['text'] = title['title']
        new_title['language'] = title['title_language']
        new_json['resource_titles'] << new_title
      end

      # 5. ['resource_acronyms']
      unless json['resource_acronyms'].blank?
        new_json['resource_acronyms'] = []
        json['resource_acronyms'].each do |acronym|
          new_acronyms = {}
          new_acronyms['text'] = acronym['acronym']
          new_acronyms['language'] = acronym['acronym_language']
          new_json['resource_acronyms'] << new_acronyms
        end
      end

      # 6. ['resource_languages']
      new_json['resource_languages'] = json['resource_language'] unless json['resource_language'].blank?

      # 7. ['resource_web_page']
      new_json['resource_web_page'] = json['resource_web_page'] unless json['resource_web_page'].blank?

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
          new_desc = {}
          new_desc['text'] = desc['description']
          new_desc['language'] = desc['description_language']
          non_english_descrs << new_desc
        end
        new_json['resource_descriptions_non_english'] = non_english_descrs unless non_english_descrs.blank?

      end


      #10. ['resource_classification']
      new_json['resource_classification'] = {}
      new_json['resource_classification']['resource_type'] = sr.studyhub_resource_type.title

      #11. ['resource_keywords']
      new_json['resource_keywords'] = json['resource_keywords'] unless json['resource_keywords'].blank?

      ###################non_study#####################

      unless sr.is_studytype?

        # 10.1. ['resource_classification']
        new_json['resource_classification']['resource_type_general'] = json['resource_type_general']

        # 11. ['resource_non_study_details']
        new_json['resource_non_study_details'] = {}
        unless json['resource_version'].blank?
          new_json['resource_non_study_details']['resource_version'] = json['resource_version']
        end
        unless json['resource_format'].blank?
          new_json['resource_non_study_details']['resource_format']  = json['resource_format']
        end


        resource_use_rights = {}

        resource_use_rights['resource_use_rights_label'] = json['resource_use_rights_label']

        if ['CC BY 4.0 (Creative Commons Attribution 4.0 International)',
            'CC BY-NC 4.0 (Creative Commons Attribution Non Commercial 4.0 International)',
            'CC BY-SA 4.0 (Creative Commons Attribution Share Alike 4.0 International)',
            'CC BY-NC-SA 4.0 (Creative Commons Attribution Non Commercial Share Alike 4.0 International)'].include? json['resource_use_rights_label']
          resource_use_rights['resource_use_rights_confirmations'] = {}
          resource_use_rights['resource_use_rights_confirmations']['resource_use_rights_authors_confirmation_1'] =
            json['resource_use_rights_authors_confirmation_1']
          resource_use_rights['resource_use_rights_confirmations']['resource_use_rights_authors_confirmation_2'] =
            json['resource_use_rights_authors_confirmation_2']
          resource_use_rights['resource_use_rights_confirmations']['resource_use_rights_authors_confirmation_3'] =
            json['resource_use_rights_authors_confirmation_3']
          resource_use_rights['resource_use_rights_confirmations']['resource_use_rights_support_by_licencing'] =
            json['resource_use_rights_support_by_licencing']
        end


        unless json['resource_use_rights_description'].blank?
          resource_use_rights['resource_use_rights_description'] = json['resource_use_rights_description']
        end
        new_json['resource_non_study_details']['resource_use_rights'] = resource_use_rights

        new_json.delete('resource_non_study_details') if new_json['resource_non_study_details'].blank?

      end

      # 12. ['study_design']
      if sr.is_studytype?

        sd = json['study_design']

        new_json['study_design'] = {}

        # ['study_design']['study_primary_design']
        new_json['study_design']['study_primary_design'] = sd['study_primary_design']

        # ['study_design']['study_type']
        new_json['study_design']['study_type'] = [sd['study_type']]

        # ['study_design']['study_conditions']
        new_json['study_design']['study_conditions'] = []
        sd['study_conditions'].each do |con|
          new_condition = {}
          new_condition['study_conditions_label'] = con['study_conditions']
          new_condition['study_conditions_classification'] = con['study_conditions_classification']
          new_condition['study_conditions_classification_code'] = con['study_conditions_classification_code']
          new_json['study_design']['study_conditions'] << new_condition
        end
        new_json['study_design'].delete('study_conditions') if new_json['study_design']['study_conditions'].blank?

        # ['study_design']['study_groups_of_diseases']
        new_json['study_design']['study_groups_of_diseases'] = {}
        new_json['study_design']['study_groups_of_diseases']['study_groups_of_diseases_generally'] = ['Unknown']


        # ['study_design']['study_ethics_committee_approval']
        unless sd['study_ethics_commitee_approval'].blank?

          new_json['study_design']['study_ethics_committee_approval'] = case sd['study_ethics_commitee_approval']
                                                                        when 'Request submitted, approval pending'
                                                                          'Request for approval submitted, approval pending'
                                                                        when 'Request submitted, approval granted'
                                                                          'Request for approval submitted, approval granted'
                                                                        when 'Request submitted, exempt granted'
                                                                          'Request for approval submitted, exempt granted'
                                                                        when 'Request submitted, approval denied'
                                                                          'Request for approval submitted, approval denied'
                                                                        when 'Unknown'
                                                                          'Unknown status of request approval'
                                                                        else
                                                                          sd['study_ethics_commitee_approval']
                                                                        end
        end


        #todo ['study_design']['study_status'], https://github.com/nfdi4health/metadataschema/issues/206
        new_json['study_design']['study_status'] = sd['study_status'] unless sd['study_status'].blank?

        if sr.is_interventional_study?
          if (sd['study_status'].start_with? 'Ongoing') || (sd['study_status'].start_with? 'At')
            new_json['study_design']['study_status_when_intervention'] = sd['study_status_when_intervention'] unless sd['study_status_when_intervention'].blank?
          end
        end



        if (sd['study_status'].start_with? 'Suspended') || (sd['study_status'].start_with? 'Terminated')
          new_json['study_design']['study_status_halted_stage'] = sd['study_status_halted_stage'] unless sd['study_status_halted_stage'].blank?
          new_json['study_design']['study_status_halted_reason'] = sd['study_status_halted_reason'] unless sd['study_status_halted_reason'].blank?
        end

        new_json['study_design']['study_status_enrolling_by_invitation'] = sd['study_status_enrolling_by_invitation'] unless sd['study_status_enrolling_by_invitation'].blank?



        # ['study_design']['study_recruitment_status_register']
        unless sd['study_recruitment_status_register'].blank?
          new_json['study_design']['study_recruitment_status_register'] = sd['study_recruitment_status_register']
        end


        # ['study_design']['study_start_date']
        new_json['study_design']['study_start_date'] = sd['study_start_date'] unless sd['study_start_date'].blank?



        # ['study_design']['study_end_date']
        new_json['study_design']['study_end_date'] = sd['study_end_date'] unless sd['study_end_date'].blank?


        # ['study_design']['study_countries']
        new_json['study_design']['study_countries'] = if sd['study_country'].blank?
                                                        []
                                                      else
                                                        sd['study_country']
                                                      end


        # ['study_design']['study_region']
        new_json['study_design']['study_region'] = sd['study_region'] unless sd['study_region'].blank?


        # ['study_design']['study_centers']
        new_json['study_design']['study_centers'] = sd['study_centers'] unless sd['study_centers'].blank?

        # ['study_design']['study_centers_number']
        new_json['study_design']['study_centers_number'] = sd['study_centers_number'] unless sd['study_centers_number'].blank?

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
        new_json['study_design']['study_sampling'] = {}

        if sd['study_sampling'].start_with?('Probability')
          new_json['study_design']['study_sampling']['study_sampling_method'] = 'Probability'
          unless sd['study_sampling'] == 'Probability'
            new_json['study_design']['study_sampling']['study_sampling_method_probability'] =
              sd['study_sampling'].partition("(").last.partition(")").first
          end

        elsif sd['study_sampling'].start_with?('Non-probability')
          new_json['study_design']['study_sampling']['study_sampling_method'] = 'Non-probability'
          unless sd['study_sampling'] == 'Non-probability'
            new_json['study_design']['study_sampling']['study_sampling_method_non_probability'] =
              sd['study_sampling'].partition("(").last.partition(")").first
          end

        else
          new_json['study_design']['study_sampling']['study_sampling_method'] =sd['study_sampling'] unless sd['study_sampling'].blank?
        end

        new_json['study_design'].delete('study_sampling') if new_json['study_design']['study_sampling'].blank?

        #['study_design']['study_data_source']
        biological_samples = ['Blood', 'Buccal cells', 'Cord blood', 'DNA', 'Faeces', 'Hair', 'Immortalized cell lines',
                              'Isolated pathogen', 'Nail', 'Plasma', 'RNA', 'Saliva', 'Serum', 'Tissue (frozen)', 'Tissue (FFPE)', 'Urine', 'Other biological samples']
        imaging_data = ['Imaging data (ultrasound)','Imaging data (MRI)','Imaging data (MRI, radiography)',
'Imaging data (CT)','Other imaging data']
        proteomics = ['Genomics','Metabolomics','Transcriptomics','Proteomics','Other omics technology']
        new_json['study_design']['study_data_source'] = {}
        new_json['study_design']['study_data_source']['study_data_sources_general'] = []
        new_json['study_design']['study_data_source']['study_data_sources_biosamples'] = []
        new_json['study_design']['study_data_source']['study_data_sources_imaging'] = []
        new_json['study_design']['study_data_source']['study_data_sources_omics'] = []
        unless sd['study_data_source_description'].blank?
          new_json['study_design']['study_data_source']['study_data_source_description'] =
            sd['study_data_source_description']
        end

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

        new_json['study_design']['study_data_source']['study_data_sources_general'] = study_data_sources_general.uniq unless study_data_sources_general.uniq.blank?
        new_json['study_design']['study_data_source'].delete('study_data_sources_general') if new_json['study_design']['study_data_source']['study_data_sources_general'].blank?
        new_json['study_design']['study_data_source'].delete('study_data_sources_biosamples') if new_json['study_design']['study_data_source']['study_data_sources_biosamples'].blank?
        new_json['study_design']['study_data_source'].delete('study_data_sources_imaging') if new_json['study_design']['study_data_source']['study_data_sources_imaging'].blank?
        new_json['study_design']['study_data_source'].delete('study_data_sources_omics') if new_json['study_design']['study_data_source']['study_data_sources_omics'].blank?
        new_json['study_design'].delete('study_data_source') if new_json['study_design']['study_data_source'].blank?

        #['study_design']['study_primary_purpose']
        new_json['study_design']['study_primary_purpose'] = sd['interventional_study_design']['study_primary_purpose'] if sr.is_interventional_study? && !sd['interventional_study_design']['study_primary_purpose'].blank?

        #['study_design']['study_eligibility_criteria']
        new_json['study_design']['study_eligibility_criteria'] = {}
        study_eligibility_age_min = {}
        study_eligibility_age_max = {}

        unless sd['study_eligibility_gender'].blank?
          new_json['study_design']['study_eligibility_criteria']['study_eligibility_genders'] =
            sd['study_eligibility_gender']
        end

        unless sd['study_eligibility_inclusion_criteria'].blank?
          new_json['study_design']['study_eligibility_criteria']['study_eligibility_inclusion_criteria'] =
            sd['study_eligibility_inclusion_criteria']
        end

        unless sd['study_eligibility_exclusion_criteria'].blank?
          new_json['study_design']['study_eligibility_criteria']['study_eligibility_exclusion_criteria'] =
            sd['study_eligibility_exclusion_criteria']
        end

        unless sd['study_eligibility_age_min'].blank?
          study_eligibility_age_min['number'] = sd['study_eligibility_age_min']
          study_eligibility_age_min['time_unit'] = nil
        end

        unless sd['study_eligibility_age_max'].blank?
          study_eligibility_age_max['number'] = sd['study_eligibility_age_max']
          study_eligibility_age_max['time_unit'] = nil
        end

        unless study_eligibility_age_min.blank?
          new_json['study_design']['study_eligibility_criteria']['study_eligibility_age_min'] =
            study_eligibility_age_min
        end

        unless study_eligibility_age_max.blank?
          new_json['study_design']['study_eligibility_criteria']['study_eligibility_age_max'] =
            study_eligibility_age_max
        end

        if new_json['study_design']['study_eligibility_criteria'].blank?
          new_json['study_design'].delete('study_eligibility_criteria')
        end

        #['study_design']['study_population']
        new_json['study_design']['study_population'] = sd['study_population'] unless sd['study_population'].blank?

        #['study_design']['study_target_sample_size']
        new_json['study_design']['study_target_sample_size'] = sd['study_target_sample_size'] unless sd['study_target_sample_size'].blank?


        #['study_design']['study_obtained_sample_size']
        new_json['study_design']['study_obtained_sample_size'] = sd['study_obtained_sample_size'] unless sd['study_obtained_sample_size'].blank?

        #['study_design']['study_age_min_examined']

        unless sd['study_age_min_examined'].blank?
          new_json['study_design']['study_age_min_examined'] = {}
          new_json['study_design']['study_age_min_examined']['number'] = sd['study_age_min_examined']
          new_json['study_design']['study_age_min_examined']['time_unit'] = nil
        end


        #['study_design']['study_age_max_examined']
        unless sd['study_age_max_examined'].blank?
          new_json['study_design']['study_age_max_examined'] = {}
          new_json['study_design']['study_age_max_examined']['number'] = sd['study_age_max_examined']
          new_json['study_design']['study_age_max_examined']['time_unit'] = nil
        end


        # ['study_design']['study_hypothesis']
        new_json['study_design']['study_hypothesis'] = sd['study_hypothesis'] unless sd['study_hypothesis'].blank?

        #['study_design']['study_arms_groups']
        if (sr.is_interventional_study? && !sd['interventional_study_design']['interventional_study_design_arms'].blank?)
          new_json['study_design']['study_arms_groups'] =  sd['interventional_study_design']['interventional_study_design_arms']
        end

        #['study_design']['study_interventions']
        if (sr.is_interventional_study? && !sd['interventional_study_design']['interventional_study_design_interventions'].blank?)
          study_interventions = []
          sd['interventional_study_design']['interventional_study_design_interventions']&.each do |old|
            new = {}
            new['study_intervention_arms_groups_label'] = old['study_intervention_arm_group_label']
            new['study_intervention_name'] = old['study_intervention_name']
            new['study_intervention_type'] = old['study_intervention_type']
            new['study_intervention_description'] = old['study_intervention_description']
            study_interventions << new
          end
          new_json['study_design']['study_interventions'] = study_interventions
        end


        #['study_design']['study_outcomes']
        new_json['study_design']['study_outcomes'] = sd['study_outcomes'] unless sd['study_outcomes'].blank?
        new_json['study_design']['study_outcomes']&.each do |out_come|
          if out_come['study_outcome_type'] == ' Secondary'
            out_come['study_outcome_type'] ='Secondary'
          end
        end

        #['study_design']['study_design_comment']
        new_json['study_design']['study_design_comment'] = sd['study_design_comment'] unless sd['study_design_comment'].blank?

        #['study_design']['study_data_sharing_plan']
        new_json['study_design']['study_data_sharing_plan'] = {}
        new_json['study_design']['study_data_sharing_plan']['study_data_sharing_plan_generally'] =
          sd['study_data_sharing_plan_generally'].chomp('.')
        unless sd['study_data_sharing_plan_description'].blank?
          new_json['study_design']['study_data_sharing_plan']['study_data_sharing_plan_description'] =
            sd['study_data_sharing_plan_description']
        end
        unless sd['study_data_sharing_plan_url'].blank?
          new_json['study_design']['study_data_sharing_plan']['study_data_sharing_plan_url'] =
            sd['study_data_sharing_plan_url']
        end


        if sd['study_data_sharing_plan_generally'] == 'Yes, there is a plan to make data available.'
          unless sd['study_data_sharing_plan_supporting_information'].blank?
            new_json['study_design']['study_data_sharing_plan']['study_data_sharing_plan_supporting_information'] =
              sd['study_data_sharing_plan_supporting_information']
          end
          unless sd['study_data_sharing_plan_time_frame'].blank?
            new_json['study_design']['study_data_sharing_plan']['study_data_sharing_plan_time_frame'] =
              sd['study_data_sharing_plan_time_frame']
          end
          unless sd['study_data_sharing_plan_access_criteria'].blank?
            new_json['study_design']['study_data_sharing_plan']['study_data_sharing_plan_access_criteria'] =
              sd['study_data_sharing_plan_access_criteria']
          end
        end


        #['study_design']['study_design_interventional']
        if sr.is_interventional_study?

          new_json['study_design']['study_design_interventional'] = {}

          #['study_design']['study_design_interventional']['study_phase']
          unless sd['interventional_study_design']['study_phase'].blank?
            new_json['study_design']['study_design_interventional']['study_phase'] =
              sd['interventional_study_design']['study_phase']
          end

          #['study_design']['study_design_interventional']['study_masking']
          new_json['study_design']['study_design_interventional']['study_masking'] = {}

          new_json['study_design']['study_design_interventional']['study_masking']['study_masking_general'] =
            sd['interventional_study_design']['study_masking'] unless sd['interventional_study_design']['study_masking'].blank?

          if sd['interventional_study_design']['study_masking']
            new_json['study_design']['study_design_interventional']['study_masking']['study_masking_roles'] =
              sd['interventional_study_design']['study_masking_roles']
          end

          if sd['interventional_study_design']['study_masking']
            new_json['study_design']['study_design_interventional']['study_masking']['study_masking_description'] =
              sd['interventional_study_design']['study_masking_description']
          end
          new_json['study_design']['study_design_interventional'].delete('study_masking') if new_json['study_design']['study_design_interventional']['study_masking'].blank?


          #['study_design']['study_design_interventional']['study_allocation']
          unless sd['interventional_study_design']['study_allocation'].blank?
            new_json['study_design']['study_design_interventional']['study_allocation'] =
              sd['interventional_study_design']['study_allocation']
          end

          #['study_design']['study_design_interventional']['study_off_label_use']
          unless sd['interventional_study_design']['study_off_label_use'].blank?
            new_json['study_design']['study_design_interventional']['study_off_label_use'] =
              sd['interventional_study_design']['study_off_label_use']
          end

          new_json['study_design'].delete('study_design_interventional') if new_json['study_design']['study_design_interventional'].blank?
        end

        #['study_design']['study_design_non_interventional']
        if sr.is_non_interventional_study?
          new_json['study_design']['study_design_non_interventional'] = {}
          unless sd['non_interventional_study_design']['study_time_perspective'].blank?
            new_json['study_design']['study_design_non_interventional']['study_time_perspectives'] =
              sd['non_interventional_study_design']['study_time_perspective']
          end
          unless sd['non_interventional_study_design']['study_target_follow-up_duration'].blank?
            new_json['study_design']['study_design_non_interventional']['study_target_followup_duration'] =
              sd['non_interventional_study_design']['study_target_follow-up_duration']
          end
          unless sd['non_interventional_study_design']['study_biospecimen_retention'].blank?
            new_json['study_design']['study_design_non_interventional']['study_biospecimen_retention'] =
              sd['non_interventional_study_design']['study_biospecimen_retention']
          end
          unless sd['non_interventional_study_design']['study_biospecomen_description'].blank?
            new_json['study_design']['study_design_non_interventional']['study_biospecimen_description'] =
              sd['non_interventional_study_design']['study_biospecomen_description']
          end
        end
        new_json['study_design'].delete('study_design_non_interventional') if new_json['study_design']['study_design_non_interventional'].blank?

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

