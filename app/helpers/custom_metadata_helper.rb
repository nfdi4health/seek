module CustomMetadataHelper
  include SamplesHelper

  def custom_metadata_form_field_for_attribute(attribute, resource)
    element_class = "custom_metadata_attribute_#{attribute.sample_attribute_type.base_type.downcase}"
    element_name = "#{resource.class.name.underscore}[custom_metadata_attributes][data][#{attribute.title}]"

    attribute_form_element(attribute, resource.custom_metadata, element_name, element_class)
  end
end

def custom_metadata_attribute_description(description)
  html = '<div class="addtional-info help-block">'
  html += '<small>' + description.split("<lb>").first + '<a href="#"> read more</a>'
  html += '</small>'
  html += '<div class="less">'
  html += '<small>'+description.split("<lb>").last+'</small>'
  html += '</div>'
  html += '</div>'
  html.html_safe
end
