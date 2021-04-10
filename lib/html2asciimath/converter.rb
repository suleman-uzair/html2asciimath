# frozen_string_literal: true

# (c) 2021 Ribose Inc.

module HTML2AsciiMath
  class Converter
    attr_reader :ast, :ast_stack, :html_parser
    attr_accessor :variable_mode

    def initialize(str)
      @ast = AST.new
      @ast_stack = [@ast]
      @variable_mode = false
      @html_parser = HTMLParser.new(str, self)
    end

    def transform
      html_parser.parse
      to_asciimath
    end

    def open_group
      ast_stack.push AST.new
    end

    def close_group
      push ast_stack.pop
    end

    def push(*objs)
      ast_stack.last.push(*objs)
    end

    def to_asciimath
      ast.to_asciimath
    end
  end
end
