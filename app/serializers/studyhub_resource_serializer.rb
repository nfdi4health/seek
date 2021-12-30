class StudyhubResourceSerializer < PCSSerializer

  attribute :studyhub_resource_type do
    object.studyhub_resource_type.try(:key)
  end

  attribute :resource_json do
    convert_resource_json('resource')
    convert_resource_json('study_design') if object.is_studytype?
    object.resource_json
  end

  has_many :projects

  attribute :content_blobs, if: -> { object.respond_to?(:content_blob) } do
    blobs = [object.content_blob].compact
    blobs.map { |cb| convert_content_blob_to_json(cb) }
  end

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

  def convert_resource_json(key)
    StudyhubResource::MULTISELECT_ATTRIBUTES_HASH[key].each do |attr|
        object.resource_json[key][attr] = display_labels_for_multi_select_attribute(object.resource_json[key][attr]) unless object.resource_json[key][attr].blank?
    end
  end

  def display_labels_for_multi_select_attribute(array)
    array.map{|x| SampleControlledVocabTerm.find(x).label}
  end

end