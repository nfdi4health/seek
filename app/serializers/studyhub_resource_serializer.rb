class StudyhubResourceSerializer < PCSSerializer

  # attribute :studyhub_resource_type do
  #   object.studyhub_resource_type.try(:key)
  # end

  attribute :resource do
    object.resource_json['resource_identifier'] = object.id.to_s
    convert_multi_select_attr
    object.resource_json
  end

  attribute :content_blobs, if: -> { !object.is_studytype? && object.respond_to?(:content_blob) } do
    blobs = [object.content_blob].compact
    blobs.map { |cb| convert_content_blob_to_json(cb) }
  end

  has_many :projects

  def convert_content_blob_to_json(cb)
    path = polymorphic_path([cb.asset, cb])
    {
      original_filename: cb.original_filename,
      url: cb.url,
      md5sum: cb.md5sum,
      sha1sum: cb.sha1sum,
      content_type: cb.content_type,
      link: "#{base_url}#{path}",
      size: cb.file_size
    }
  end


  def convert_multi_select_attr
    StudyhubResource::MULTISELECT_ATTRIBUTES_HASH_2_1.keys.each do |key|
      StudyhubResource::MULTISELECT_ATTRIBUTES_HASH_2_1[key].each do |attr|

        if key == 'resource'
          object.resource_json[attr] = convert_id_to_label_for_multi_select_attribute(object.resource_json[attr]) unless object.resource_json[attr].blank?
        end


        if object.is_studytype?

          study_design = object.resource_json['study_design']

          study_design[attr] =
            convert_id_to_label_for_multi_select_attribute(study_design[attr]) unless study_design[attr].blank?


          if key == 'study_data_source'
            study_design['study_data_source'][attr] =
              convert_id_to_label_for_multi_select_attribute(study_design['study_data_source'][attr]) unless study_design['study_data_source'][attr].blank?
          end

          if key == 'study_eligibility_criteria'
            study_design['study_eligibility_criteria'][attr] =
              convert_id_to_label_for_multi_select_attribute(study_design['study_eligibility_criteria'][attr]) unless study_design['study_eligibility_criteria'][attr].blank?
          end

          if key == 'study_data_sharing_plan'
            study_design['study_data_sharing_plan'][attr] =
              convert_id_to_label_for_multi_select_attribute(study_design['study_data_sharing_plan'][attr]) unless study_design['study_data_sharing_plan'][attr].blank?
          end

          if object.is_non_interventional_study? && key == 'study_design_non_interventional'
            study_design['study_design_non_interventional'][attr] =
              convert_id_to_label_for_multi_select_attribute(study_design['study_design_non_interventional'][attr]) unless study_design['study_design_non_interventional'][attr].blank?
          end

          if object.is_interventional_study? && key == 'study_masking'
            unless study_design['study_design_interventional']['study_masking'][attr].blank?
              study_design['study_design_interventional']['study_masking'][attr]= convert_id_to_label_for_multi_select_attribute(study_design['study_design_interventional']['study_masking'][attr])
            end
          end
        end
      end
    end
  end





  def convert_id_to_label_for_multi_select_attribute(array)
    array.map{|x| SampleControlledVocabTerm.find(x).label}
  end

end