class StudyhubResourceSerializer < PCSSerializer

  attribute :studyhub_resource_type do
      object.studyhub_resource_type.try(:key)
  end

  attributes :resource_json

  has_many :projects

  attribute :content_blob, if: -> { object.respond_to?(:content_blob) } do
    blob = object.content_blob
    convert_content_blob_to_json(blob)
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

end