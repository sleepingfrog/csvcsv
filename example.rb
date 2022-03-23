require 'csv'
require './csv_helper'

class Example
  include CsvHelper

  private_class_method :new

  def self.call
    new.call
  end

  def initialize
    @params = [
      { foo: 'foo', bar: 'bar' },
      { foo: 1, bar: 2, baz: 3 }
    ]
  end

  def call
    CSV.generate do |csv|
      csv << headers
      @params.each do |param|
        csv << row(param)
      end
    end
  end

  add_column('foo') do |foo:|
    foo
  end

  add_column('foobar') do |foo:, bar:|
    foo.to_s + bar.to_s
  end

  add_column('foobaz') do |foo:, baz: 'BAZ'|
    foo.to_s + baz.to_s
  end

  add_column('foo*2') do |foo:|
    foo.to_s * 2
  end
end

# Example.call
# => "foo,foobar,foobaz,foo*2\nfoo,foobar,fooBAZ,foofoo\n1,12,13,11\n"

