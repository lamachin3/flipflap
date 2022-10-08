# frozen_string_literal: true

# Module that can be included (mixin) to take and output TSV data
module TsvBuddy
  # take_tsv: converts a String with TSV data into @data
  # parameter: tsv - a String in TSV format
  def take_tsv(tsv)
    @data = []
    titles = str_titles(tsv)
    tsv.each_line do |line|
      next if line == tsv.lines.first

      @data << parse_tsv_line(titles, line)
    end
    @data
  end

  def str_titles(tsv)
    tsv.lines.first.split(/[\t,\n]/)
  end

  def parse_tsv_line(titles, line)
    hash = {}
    line.split("\t").each_with_index do |element, elmt_index|
      hash[titles[elmt_index]] = element.chomp
    end
    hash
  end

  # to_tsv: converts @data into tsv string
  # returns: String in TSV format
  def to_tsv
    tsv_str = hash_titles
    tsv_str += hash_to_tab_separated
    tsv_str
  end

  def hash_titles
    titles = @data.first.keys
    str = ''
    titles.each do |title|
      str += "\t" unless first_arr_element?(titles, title)
      str += title.to_s
    end
    "#{str}\n"
  end

  def first_arr_element?(arr, key)
    key == arr.first
  end

  def hash_to_tab_separated
    str = ''
    @data.each do |row|
      row.each do |key, value|
        str += first_hash_element?(row, key) ? value.to_s : "\t#{value}"
      end
      str += "\n"
    end
    str
  end

  def first_hash_element?(hash, key)
    key == hash.first.first
  end
end
