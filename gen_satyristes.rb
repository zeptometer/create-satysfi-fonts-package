# frozen_string_literal: true

require 'erb'
require 'digest'

SATYRISTES_TEMPLATE = <<~OPAM
  (version 0.0.2)
  (library
    (name "<%= yml['name'] %>")
    (version "<%= yml['font-metadata']['version'] %>")
    (sources
      ((hash "fonts.satysfi-hash" "fonts.satysfi-hash")
       (hash "mathfonts.satysfi-hash" "mathfonts.satysfi-hash")
       <% for font in yml['font-list'] do %>
       (font "<%= font['file'] %>" "<%= yml['font-archive']['expand-dir'] %>/<%= font['file'] %>")
       <% end %>
       ))
    (opam "satysfi-<%= yml['name'] %>.opam"))
  (libraryDoc
    (name "<%= yml['name'] %>-doc")
    (version "<%= yml['font-metadata']['version'] %>")
    (build
      ((satysfi "doc-<%= yml['name'] %>.saty" "-o" "doc-<%= yml['name'] %>.pdf")))
    (sources
      ((doc "doc-<%= yml['name'] %>.pdf" "./doc-<%= yml['name'] %>.pdf")))
    (opam "satysfi-<%= yml['name'] %>-doc.opam")
    (dependencies ((<%= yml['name'] %> ()))))
OPAM

def gen_satyristes(yml)
  ERB.new(SATYRISTES_TEMPLATE)
     .result(binding)
end
