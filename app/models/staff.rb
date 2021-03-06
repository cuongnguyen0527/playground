require 'csv'

class Staff < ApplicationRecord
  def self.to_csv
    columns = %i(id first_name last_name date_of_birth point)
    headers = columns.map { |column| Staff.human_attribute_name column }

    CSV.generate("\xEF\xBB\xBF", headers: true) do |csv|
      csv << headers
      find_each do |staff|
        csv << staff.csv_row(columns)
      end
    end
  end

  def self.import_from_csv(csv)
    rows = CSV.read(csv, headers: true, converters: %i(integer date))
    rows.each do |row|
      data = row.to_h
      Staff.create(
        first_name: data['First name'],
        last_name: data['Last name'],
        date_of_birth: data['Date of birth'],
        point: data['Point']
      )
    end
  end

  def csv_row(cols)
    cols.map { |col| self[col] }
  end
end
