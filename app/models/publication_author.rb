class PublicationAuthor < ApplicationRecord
  belongs_to :publication
  belongs_to :person

  default_scope -> { order('author_index') }

  include Seek::Rdf::ReactToAssociatedChange
  update_rdf_on_change :publication

  attr_accessor :suggested_person

  def full_name
    "#{first_name} #{last_name}"
  end
  alias_method :name, :full_name

  # @param full_name e.g. "Joe J. Shmoe"
  # @return [first_name, last_name] eg . ["Joe J.", "Shmoe"]
  def self.split_full_name full_name
    full_name_split = full_name.split(" ")
    first_name = ""
    last_name = ""

    if full_name_split.length == 1
      last_name = full_name_split[0]
    elsif full_name_split.length > 1
      last_name = full_name_split.pop
      first_name = full_name_split.join " "
    end
    return first_name, last_name
  end

end
