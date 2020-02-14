# frozen_string_literal: true

require 'erb'

README_TEMPLATE = <<~TEMPLATE
  # SATySFi-<%= yml['name'] %>
  [SATySFi](https://github.com/gfngfn/SATySFi) Font Library with [Satyrographos](https://github.com/na4zagin3/satyrographos): [<%= yml['font-metadata']['name'] %>](<%= yml['font-metadata']['url'] %>)

  To use this font, please install this package followed by `satyrographos install`.

  ## Installation
  ### Install SATySFi & Satyrographos
  If you don't have them, please install them with this [instruction](https://github.com/na4zagin3/satyrographos).

  ### Install SATySFi-<%= yml['name'] %>
  ```sh
  $ opam pin add "<%= yml['site']['dev-repo'] %>"
  $ opam install satysfi-<%= yml['name'] %>
  $ satyrographos install
  ```

  if you get error `bash: satyrographos: command not found`, please read the [instruction of satyrographos](https://github.com/na4zagin3/satyrographos).

  ## Installed Fonts
  This package install the following fonts.

  | SATySFi Font Name | Font Filename | Font Type |
  |-------------------|---------------|-----------|
  <% for font in yml['font-list'] do %>| <%= yml['name'] %>:<%= font['name'] %> | <%= font['file'] %> | <%= font['type'] %> |
  <% end %>
TEMPLATE

def gen_readme(yml)
  ERB.new(README_TEMPLATE)
     .result(binding)
end
