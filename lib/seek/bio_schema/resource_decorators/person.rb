module Seek
  module BioSchema
    module ResourceDecorators
      # Decorator that provides extensions for a Person
      class Person < Thing
        PERSON_PROFILE = 'https://bioschemas.org/profiles/Person/0.2-DRAFT-2019_07_19/'

        associated_items member_of: :projects,
                         work_location: :institutions

        schema_mappings first_name: :givenName,
                        last_name: :familyName,
                        image: :image,
                        member_of: :memberOf,
                        orcid: :orcid,
                        work_location: :workLocation

        def conformance
          PERSON_PROFILE
        end
  
        def url
          web_page.blank? ? identifier : web_page
        end
      end
    end
  end
end
