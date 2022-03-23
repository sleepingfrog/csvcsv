module CsvHelper
  class Column
    attr_reader :header

    def initialize(header:, block:)
      @header = header.to_s
      @proc = block
    end

    def cell(receiver, values)
      kwargs = project(values)
      if receiver
        receiver.instance_exec(**kwargs, &@proc)
      else
        @proc.call(**kwargs)
      end
    end

    private

    def project(values)
      raise 'use keyword argument' if @proc.parameters.any? { |kind, | %i[req opt rest].include?(kind) }
      if @proc.parameters.any? { |kind, | kind == :keyrest }
        # pass all values
        values.dup
      else
        kwarg_names = @proc.parameters.each_with_object([]) do |(kind, name), ary|
          ary << name if %i[key keyreq].include?(kind)
        end
        values.slice(*kwarg_names)
      end
    end
  end
end
