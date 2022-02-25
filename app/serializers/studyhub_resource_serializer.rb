class StudyhubResourceSerializer < PCSSerializer

  # attribute :studyhub_resource_type do
  #   object.studyhub_resource_type.try(:key)
  # end

  attribute :resource do
    object.resource_json['resource_id'] = object.id.to_s
    object.resource_json['resource_type'] = object.studyhub_resource_type.try(:title)
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
      StudyhubResource::MULTISELECT_ATTRIBUTES_HASH.keys.each do |key|
        StudyhubResource::MULTISELECT_ATTRIBUTES_HASH[key].each do |attr|

          if key == 'resource'
            object.resource_json[attr] = convert_id_to_label_for_multi_select_attribute(object.resource_json[attr]) unless object.resource_json[attr].blank?
          end

          if object.is_studytype?

            object.resource_json['study_design'][attr] =
              convert_id_to_label_for_multi_select_attribute(object.resource_json['study_design'][attr]) unless object.resource_json['study_design'][attr].blank?

            case object.get_study_primary_design_type
            when StudyhubResource::INTERVENTIONAL
              object.resource_json['study_design']['interventional_study_design'][attr] =
  convert_id_to_label_for_multi_select_attribute(object.resource_json['study_design']['interventional_study_design'][attr]) unless object.resource_json['study_design']['interventional_study_design'][attr].blank?
            when StudyhubResource::NON_INTERVENTIONAL
              object.resource_json['study_design']['non_interventional_study_design'][attr] =
                convert_id_to_label_for_multi_select_attribute(object.resource_json['study_design']['non_interventional_study_design'][attr]) unless object.resource_json['study_design']['non_interventional_study_design'][attr].blank?
          end

          end
        end
      end
    end


  def convert_id_to_label_for_multi_select_attribute(array)
    array.map{|x| SampleControlledVocabTerm.find(x).label}
  end

end