# frozen_string_literal: true

# (c) 2021 Ribose Inc.

require "strscan"

module HTML2AsciiMath
  class Converter < StringScanner
    def transform
      scan_input
      to_asciimath
    end

    private

    def scan_input
      repeat_until_error_or_eos do
        skip_ws or scan_entity or scan_number or scan_error
      end
    end

    def repeat_until_error_or_eos
      catch(:error) do
        yield until eos?
      end
    end

    def scan_error
      throw :error
    end

    def skip_ws
      skip(/\s+/)
    end

    def scan_entity
      str = scan(/&\w+;/) or return
      ent_name = str[1..-2]

      if allowed_entity?(ent_name)
        symbol = ENTITY_TRANSLATIONS[ent_name] || ent_name
        # TODO accept symbol
        true
      else
        unscan
        false
      end
    end

    def scan_number
      number = scan(/\d+/) or return # TODO non-integers
      # TODO accept number
      true
    end

    def allowed_entity?(ent_name)
      ALLOWED_ENTITIES.include?(ent_name) ? ent_name : nil
    end

    def to_asciimath
      return "Converted expression" # TODO
    end

    GREEK_ALPHABET = %w[
      alpha beta gamma delta epsilon zeta eta theta iota kappa lambda mu nu xi
      omicron pi rho sigma tau upsilon phi chi psi omega
    ].freeze

    ENTITY_TRANSLATIONS = {
      "ne" => "!=",
      "lt" => "<",
      "le" => "<=",
      "gt" => ">",
      "ge" => ">=",
      "sdot" => "*",
      "times" => "xx",
      "divide" => "-:",
      "infin" => "oo",
      "forall" => "VV",
      "exist" => "EE",
    }.freeze

    ALLOWED_ENTITIES = [
      *GREEK_ALPHABET,
      *GREEK_ALPHABET.map { |l| l.capitalize },
      *GREEK_ALPHABET.map { |l| "var#{l}" }, # varpi, vartheta, etc.
      *ENTITY_TRANSLATIONS.keys,
      "not",
    ].to_set.freeze
  end
end
