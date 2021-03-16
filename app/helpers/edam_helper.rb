module EdamHelper

  require 'csv'

  @@edam_table = nil
  @@data_json = []
  @@format_json = []

  def self.ensure_edam_table
    file = File.join(Rails.root, 'public', 'EDAM.csv')
    @@edam_table = CSV.parse(File.read(file), headers: true)

  end

  def self.edam_table
    ensure_edam_table
    return @@edam_table
  end
  
  def self.data_json
    ensure_edam_table
     
    @@edam_table.each do |r|
      if r['Obsolete'] == 'TRUE'
        next
      end
      row_id = r['Class ID'].split('/')[-1]
      unless row_id.starts_with?('data')
        next
      end
      parents = r['Parents'].split('|')
      text = r['Preferred Label']
      parents.each do |p|
        parent_id = p.split('/')[-1]
        unless parent_id.starts_with?('data_')
          parent_id = 'squiggle'
        end
        new_row = {"id" => row_id,
                   "parent" => parent_id,
                   "text" => "fred"}
        @@data_json << new_row
      end
    end
    return @@data_json
  end
  
  def self.format_json
    ensure_edam_table
    return @@format_json
  end
  
  def self.url_to_text(url)
    ensure_edam_table
    if url.include? '#'
      url = url.partition('#').last
    end
    result = nil
    row = @@edam_table.find {|row| row['Class ID'] == url}
    result = row['Preferred Label'] unless row.nil?
    return result
  end
end
