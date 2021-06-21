class AddContributorAndPolicyAndUuidAndFirstLetterToStudyhubResources < ActiveRecord::Migration[5.2]
  def change
    add_column :studyhub_resources, :contributor_id, :integer
    add_column  :studyhub_resources, :policy_id, :integer
    add_column :studyhub_resources,:uuid,:string
    add_column :studyhub_resources,:first_letter,:string, :limit => 1
  end
end
