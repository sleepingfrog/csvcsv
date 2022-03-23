require 'active_support/concern'
require './csv_helper/column.rb'

module CsvHelper
  extend ActiveSupport::Concern

  module ClassMethods
    def headers
      columns.map(&:header)
    end

    def columns
      return @columns if instance_variable_defined?(:@columns)

      @columns = []
    end
    
    def add_column(header, &block)
      columns << Column.new(header: header, block: block)
    end
  end

  def columns
    self.class.columns
  end

  def headers
    self.class.headers
  end

  def row(values)
    columns.map do |column|
      column.cell(self, values)
    end
  end
end

