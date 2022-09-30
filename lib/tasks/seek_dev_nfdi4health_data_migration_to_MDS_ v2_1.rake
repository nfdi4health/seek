require 'json'

namespace :seek_dev_nfdi4health_update_to_MDS_v2_1 do

  task(add_new_values_to_study_data_source: :environment) do
    scv= SampleControlledVocab.where(title: 'NFDI4Health Study Data Source').first
    scv.sample_controlled_vocab_terms << SampleControlledVocabTerm.find_or_create_by(label: 'Biological samples')
    scv.sample_controlled_vocab_terms << SampleControlledVocabTerm.find_or_create_by(label: 'Imaging data')
    scv.sample_controlled_vocab_terms << SampleControlledVocabTerm.find_or_create_by(label: 'Omics technology')
    scv.save!
  end

end

