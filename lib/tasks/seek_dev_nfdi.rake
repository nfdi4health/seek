require 'csv'

namespace :seek_dev_nfdi do

  task :build_nfdi_study_custom_metadata_schema, [:path] => [:environment] do |t, args|
    path = args.path
    puts "Using CSV at #{path}"
    cmt_already_exist = CustomMetadataType.where(title: 'NFDI4Health Study metadata').any?
    if cmt_already_exist
      puts "CMT for NFDI Study already exists do want to overwrite with your modification y/N"
      answer = STDIN.gets.chomp.to_s.downcase
      if (!answer == "y" || !answer == "yes")
        cmt_already_exist = true
      elsif (answer == "y" || answer == "yes")
        old_cmt = CustomMetadataType.where(title: 'NFDI4Health Study metadata')
        id = old_cmt.first.id
        old_cmt.destroy_all
        CustomMetadataAttribute.where(custom_metadata_type_id: id).destroy_all
        CustomMetadata.where(custom_metadata_type_id: id).destroy_all
        cmt_already_exist = false
      end
    else
      cmt_already_exist = false
    end

    unless cmt_already_exist
      studies = CSV.read(path)
      cmt = CustomMetadataType.new(title: 'NFDI4Health Study metadata', supported_type: 'Study')

      studies.each do |study|
        title = study[0]
        if study[1] == "Mandatory"
          required = true
        else
          required = false
        end
        sample_attribute_type = study[2]
        cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: title, required: required, sample_attribute_type: SampleAttributeType.where(title: sample_attribute_type).first)
      end
      cmt.save!
      puts "Created NFDI4Health Study metadata"
    else
      puts "CMT for NFDI4Health Study metadata already exists"
    end
  end
  task :build_nfdi_assay_custom_metadata_schema, [:path] => [:environment] do |t, args|
    path = args.path
    puts "Using CSV at #{path}"


    cmt_already_exist = CustomMetadataType.where(title: 'NFDI4Health Resource metadata').any?
    if cmt_already_exist
      puts "CMT for NFDI Resource already exists do want to overwrite with your modification y/N"
      answer = STDIN.gets.chomp.to_s.downcase
      if (!answer == "y" || !answer == "yes")
        cmt_already_exist = true
      elsif (answer == "y" || answer == "yes")
        old_cmt = CustomMetadataType.where(title: 'NFDI4Health Resource metadata')
        id = old_cmt.first.id
        old_cmt.destroy_all
        CustomMetadataAttribute.where(custom_metadata_type_id: id).destroy_all
        CustomMetadata.where(custom_metadata_type_id: id).destroy_all
        cmt_already_exist = false
      end
    else
      cmt_already_exist = false
    end

    unless cmt_already_exist
      assays = CSV.read(path)
      cmt = CustomMetadataType.new(title: 'NFDI4Health Resource metadata', supported_type: 'Assay')

      assays.each do |assay|
        title = assay[0]
        if assay[1] == "Mandatory"
          required = true
        else
          required = false
        end
        sample_attribute_type = assay[2]
        cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: title, required: required, sample_attribute_type: SampleAttributeType.where(title: sample_attribute_type).first)
      end
      cmt.save!
      puts "Created NFDI4Health Resource metadata"
    else
      puts "CMT for NFDI4Health Resource metadata already exists"
    end
  end

  task :import_nfdi_study, [:path, :investigation_id, :admin_user_id] => [:environment] do |t, args|

    path = args.path
    investigation_id = args.investigation_id
    admin_user = args.admin_user_id
    user = User.find(admin_user)
    investigation = Investigation.find(investigation_id)

    puts user.display_name.inspect
    puts investigation.title
    puts "Using CSV at #{path}"

    cmt = CustomMetadataType.where(title: 'NFDI4Health Study metadata').first
    # disable_authorization_checks { investigation.studies.destroy_all }

    CustomMetadata.where(custom_metadata_type_id: cmt.id, item_type: "Study").each do |cm|
      disable_authorization_checks { Study.find(cm.item_id).destroy }
      puts "Remove Study id " + cm.item_id.to_s
    end


    CSV.foreach(path, headers: true) do |row|

      if row["id_date"] == "NULL"
        id_date = nil
      else
        # id_date = Date::strptime(row["id_date"], "%m/%d/%y")
        id_date = Date::strptime(row["id_date"], "%Y-%m-%d")
      end

      if row["study_start_date"] == "NULL"
        study_start_date = nil
      else
        study_start_date = Date::strptime(row["study_start_date"], "%Y-%m-%d")
      end

      if row["study_end_date"] == "NULL"
        study_end_date = nil
      else
        study_end_date = Date::strptime(row["study_end_date"], "%Y-%m-%d")
      end

      metadata = {
          "parent_id": row["parent_id"].to_i,
          "resource_id": row["resource_id"],
          "resource_type": row["resource_type"],
          "resource_type_general": row["resource_type_general"],
          "resource_language": row["resource_language"],
          "resource_web_page": row["resource_web_page"],
          "resource_web_studyhub": row["resource_web_studyhub"],
          "resource_web_seek": row["resource_web_seek"],
          "resource_web_mica": row["resource_web_mica"],
          "resource_use_rights": row["resource_use_rights"],
          "resource_source": row["resource_source"],
          "description_text": row["description_text"],
          "description_type": row["description_type"],
          "description_language": row["description_language"],
          "title": row["title"],
          "title_type": row["title_type"],
          "title_language": row["title_language"],
          "acronym": row["acronym"],
          "acronym_type": row["acronym_type"],
          "id_type": row["id_type"],
          "id": row["id"],
          "id_date": id_date,
          "id_relation_type": row["id_relation_type"],
          "study_primary_design": row["study_primary_design"],
          "study_type": row["study_type"],
          "study_analysis_unit": row["study_analysis_unit"],
          "study_status": row["study_status"],
          "study_eligibility": row["study_eligibility"],
          "study_sampling": row["study_sampling"],
          "study_country": row["study_country"],
          "study_region": row["study_region"],
          "study_conditions": row["study_conditions"],
          "study_population": row["study_population"],
          "study_target_sample_size": row["study_target_sample_size"],
          "study_obtained_sample_size": row["study_obtained_sample_size"],
          "study_age_min": row["study_age_min"],
          "study_age_max": row["study_age_max"],
          "study_start_date": study_start_date,
          "study_end_date": study_end_date,
          "study_design_comment": row["study_design_comment"],
          "study_datasource": row["study_datasource"],
          "study_interventions": row["study_interventions"],
          "study_primary_outcomes": row["study_primary_outcomes"],
          "study_secondary_outcomes": row["study_secondary_outcomes"],
          "study_hypothesis": row["study_hypothesis"],
          "study_phase": row["study_phase"]}

      metadata.each { |k, v| metadata[k] = nil if v == "NULL" }

      User.with_current_user(user) do
        study = Study.new(title: row["title"],
                          investigation: investigation,
                          custom_metadata: CustomMetadata.new(
                              custom_metadata_type: cmt,
                              data: metadata
                          ))
        study.policy = Policy.new(name: 'default public',
                                  access_type: 2)

        puts "____________________________"
        puts "create Study " + study.title
        study.save!
      end
    end
  end

  task :import_nfdi_assay, [:path, :other_study_id, :admin_user_id] => [:environment] do |t, args|

    path = args.path
    other_study_id = args.other_study_id
    admin_user = args.admin_user_id
    user = User.find(admin_user)

    puts user.display_name.inspect
    puts "Using CSV at #{path}"

    cmt = CustomMetadataType.where(title: 'NFDI4Health Resource metadata').first

    CustomMetadata.where(custom_metadata_type_id: cmt.id, item_type: "Assay").each do |cm|
      disable_authorization_checks { Assay.find(cm.item_id).destroy }
      puts "Remove Assay id " + cm.item_id.to_s
      disable_authorization_checks { cm.destroy }
    end

    CSV.foreach(path, headers: true) do |row|
      parent_study = nil
      puts "_________________________________________"
      puts row["parent_id"].inspect

      # find the study of the resource
      if row["parent_id"]!="NULL"
        cm = CustomMetadata.where("item_type = ? AND json_metadata like ?", "Study", "%#{row["parent_id"]}%").first
        parent_study= Study.find(cm.item_id) unless cm.nil?
      else
        parent_study = Study.find(other_study_id) unless other_study_id.nil?
      end


      unless parent_study.nil?
        puts parent_study.title
        if row["id_date"] == "NULL"
          id_date = nil
        else
          id_date = Date::strptime(row["id_date"], "%m/%d/%y")
        end

        metadata = {
            "parent_id": row["parent_id"].to_i,
            "resource_id": row["resource_id"],
            "resource_type": row["resource_type"],
            "resource_type_general": row["resource_type_general"],
            "resource_language": row["resource_language"],
            "resource_web_page": row["resource_web_page"],
            "resource_web_studyhub": row["resource_web_studyhub"],
            "resource_web_seek": row["resource_web_seek"],
            "resource_web_mica": row["resource_web_mica"],
            "resource_use_rights": row["resource_use_rights"],
            "resource_source": row["resource_source"],
            "description_text": row["description_text"],
            "description_type": row["description_type"],
            "description_language": row["description_language"],
            "title": row["title"],
            "title_type": row["title_type"],
            "title_language": row["title_language"],
            "acronym": row["acronym"],
            "acronym_type": row["acronym_type"],
            "id_type": row["id_type"],
            "id": row["id"],
            "id_date": id_date,
            "id_relation_type": row["id_relation_type"]}

        metadata.each { |k, v| metadata[k] = nil if v == "NULL" }

        User.with_current_user(user) do
          resource = Assay.new(title: row["title"],
                               study: parent_study,
                               assay_class_id: AssayClass.where(key: "MODEL").first.id,
                               custom_metadata: CustomMetadata.new(
                                   custom_metadata_type: cmt,
                                   data: metadata
                               ))
          resource.policy = Policy.new(name: 'default public',
                                       access_type: 2)

          puts "create Resource " + resource.title
          resource.save!
        end
      else
        puts "I can not find the study for resource id " + row["parent_id"].to_s
      end

    end
  end

end