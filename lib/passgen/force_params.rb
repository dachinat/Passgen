module Passgen
  class ForceParams
    class << self
      SYMBOL_RE = /([\!\@\#\$\%\&\/\(\)\+\?\*])/
      DIGIT_RE = /([\d])/
      LOWERCASE_RE = /([a-z])/
      UPPERCASE_RE = /([A-Z])/

      def regenerate(pw, params, tokens)
        if params[:pronounceable] == true || params[:digits_before] || params[:digits_after]
          raise StandardError.new("Force params won't work with ':pronounceable', ':digits_before' and ':digits_after'")
        end

        while !is_strong_enough(pw, params)
          pw = Passgen::generate_one(tokens)
        end
        pw
      end

      def is_strong_enough(pw, params)
        raise StandardError.new("Insufficient length") unless has_sufficient_length(pw, params)

        return false unless pw.index(SYMBOL_RE) if params[:symbols]
        return false unless pw.index(DIGIT_RE) if params[:digits]
        return false unless pw.index(LOWERCASE_RE) if params[:lowercase]
        return false unless pw.index(UPPERCASE_RE) if params[:uppercase]
        true
      end

      def has_sufficient_length(pw, params)
        length = 0
        [:symbols, :digits, :lowercase, :uppercase].each { |s| length += 1 if params[s] }
        pw.length >= length
      end
    end
  end
end
