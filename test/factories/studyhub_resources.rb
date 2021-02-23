require 'json'
  max_studyhub_study_json_text = '{"studySecondaryOutcomes": null, "studyAnalysisUnit": "Individual", "acronyms": [{"type": "Original", "acronym": "SHARE"}], "studyPopulation": "Older individuals", "studyDesignComment": null, "studyEndDate": null, "studyObtainedSampleSize": null, "childs": [20004, 50005], "studyType": "Cohort", "studyRegion": null, "webSeek": "https://seek.studyhub.nfdi4health.de/documents/19", "source": "manually collected", "studyInterventions": null, "studyDatasource": null, "studyEligibility": null, "studyCountry": "Denmark, Sweden, Austria, Germany, France, Belgium, Netherlands, Switzerland, Greece, Italy, Spain", "parents": [], "webMica": null, "contacts": [{"email": "info@share-project.org", "type": "Contact person", "specificType": null, "name": "SHARE Central", "webPage": "", "phone": "", "address": "", "specificNumber": null}, {"email": "boersch-supan@mea.mpisoc.mpg.de", "type": "Principal investigator", "specificType": null, "name": "Prof. Axel Bu00f6rsch-Supan", "webPage": "", "phone": "+49 (0)893 8602355", "address": "Munich Center for the Economics of Aging (MEA), Max Planck Institute for Social Law and Social Policy, Technical University of Munich, Amalienstr. 33, 80799 Munich, Germany", "specificNumber": null}], "hasAssociatedDocuments": false, "language": null, "titles": [{"type": "Original", "title": "Survey of Health, Ageing and Retirement in Europe (SHARE)", "language": "EN"}], "studyHypothesis": null, "hasAssociatedInstruments": true, "descriptions": [{"type": "offical", "text": "The main aim of SHARE is understanding ageing and how it affects individuals in the diverse cultural settings of Europe.", "language": "EN"}, {"type": "created", "text": "The main aim of SHARE is understanding ageing and how it affects individuals in the diverse cultural settings of Europe.", "language": "EN"}], "studyAgeMin": 50, "resourceType": "Study", "webPage": "http://www.share-project.org/home0.html", "studyPrimaryOutcomes": null, "studyStatus": "Recruiting", "studyPrimaryDesign": "Non-interventional", "studySampling": null, "studyStartDate": null, "studyPhase": null, "studyTargetSampleSize": 27000, "studyAgeMax": -1, "webStudyhub": "http://covid19.studyhub.nfdi4health.de/resource/10004", "alternativeIds": [], "resourceId": 10004, "useRights": "EN", "studyConditions": null}'
max_studyhub_study_json = JSON.parse(max_studyhub_study_json_text)

# StudyhubResource
Factory.define(:studyhub_study, class: StudyhubResource) do |f|
  f.sequence(:resource_id) { |n| n }
  f.resource_type 'study'
end

Factory.define(:max_studyhub_study, class: StudyhubResource) do |f|
  f.parent_id nil
  f.resource_id 10004
  f.resource_type 'study'
  f.resource_json max_studyhub_study_json
  f.NFDI_person_in_charge nil
  f.contact_stage '9'
  f.data_source 'RatSWD'
  f.comment nil
  f.Exclusion_MICA_reason 'Not applicable'
  f.Exclusion_SEEK_reason nil
  f.Exclusion_StudyHub_reason nil
  f.Inclusion_Studyhub 1
  f.Inclusion_SEEK 1
  f.Inclusion_MICA 1
end

Factory.define(:studyhub_assay, class: StudyhubResource) do |f|
  f.sequence(:resource_id) { |n| n }
  f.resource_type 'assay'
end