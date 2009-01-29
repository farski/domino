module Domino  
  class Attribute
    def initialize(name, value)
      @name = name.to_s
      @value = (value == true ? name.to_s : value)
    end
    
    def to_s
      @name + '="' + @value + '"'
    end    
  end
  
  class Element
    def initialize(name = nil, attributes = nil, singleton = false, &block)
      if name
        @name = name
        @sigleton = singleton        
        @attributes = attributes.inject(Array.new) { |collection, attribute| collection << Domino::Attribute.new(attribute[0], attribute[1])} if attributes
      end
      
      @contents = (block_given? ? [yield(block)] : [])
    end
    
    def push(element)
      @contents << element
      return self
    end
    
    def inject_into(element)
      element.push(self)
      return self
    end
    
    def start_or_singleton_tag_definition
      attributes_markup = @attributes.inject(Array.new) { |collection, attribute| collection << attribute.to_s } if @attributes
      [@name.to_s, attributes_markup].compact.join(" ")
    end
    
    def start_tag
      '<' + start_or_singleton_tag_definition + '>'
    end
    
    def singleton_tag
      '<' + start_or_singleton_tag_definition + ' />'
    end
    
    def end_tag
      '</' + @name.to_s + '>'
    end
    
    def markup
      @singleton ? singleton_tag : [start_tag, @contents, end_tag].join
    end
    
    def to_s
      @name ? markup : @contents.join
    end    
  end
end
