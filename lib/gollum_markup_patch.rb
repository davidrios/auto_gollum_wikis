module Gollum
  class Markup
    def process_headers(doc)
      toc = nil
      level_stack = nil
      li_node = nil

      doc.css('h1,h2,h3,h4,h5,h6').each do |h|
        # must escape "
        h_name = h.content.gsub(' ','-').gsub('"','%22')

        level = h.name.gsub(/[hH]/,'').to_i

        # Add anchors
        h.add_previous_sibling(%Q{<a name="#{h_name}"></a>})
        h.add_child(%Q{<a class="wiki-anchor" href="##{h_name}">&para;</a>})

        # Build TOC
        toc ||= Nokogiri::XML::DocumentFragment.parse('<ul class="toc right"></ul>')
        level_stack ||= [toc.child]

        if level > level_stack.length
          node = Nokogiri::XML::Node.new('ul', doc)
          level_stack.push li_node.add_child(node)
        end

        while level < level_stack.length
          level_stack.pop
        end

        li_node = Nokogiri::XML::Node.new('li', doc)
        li_node.add_child(%Q{<a href="##{h_name}">#{h.content.chop}</a>})
        level_stack.last.add_child(li_node)
      end

      toc = toc.to_xml(@to_xml) if toc != nil
      [doc, toc]
    end

    old_process_page_link_tag = instance_method(:process_page_link_tag)
    define_method(:process_page_link_tag) do |tag|
      old_process_page_link_tag.bind(self).(tag).sub('"internal absent"', '"internal new"')
    end
  end
end