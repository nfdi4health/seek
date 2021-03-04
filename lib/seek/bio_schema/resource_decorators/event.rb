module Seek
  module BioSchema
    module ResourceDecorators
      # Decorator that provides extensions for a Event
      class Event < Thing
        associated_items contact: :contributors,
                         host_institution: :projects
        schema_mappings contact: :contact,
                        start_date: :startDate,
                        end_date: :endDate,
                        event_type: :eventType,
                        location: :location,
                        host_institution: :hostInstitution,
                        conformsTo: "dct:conformsTo"

        def conformsTo
          'https://bioschemas.org/profiles/Event/0.2-DRAFT-2019_06_14/'
        end
        
        def contributors
          [contributor]
        end

        def end_date
          if (end_date = resource.end_date).blank?
            resource.start_date
          else
            end_date
          end
        end

        def event_type
          []
        end

        def location
          [address, city, country].reject(&:blank?).join(', ')
        end

        def country
          CountryCodes.country(resource.country)
        end
      end
    end
  end
end
