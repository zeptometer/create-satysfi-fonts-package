# frozen_string_literal: true

require 'erb'
require 'digest'

DOC_SATY_TEMPLATE = <<~TEMPLATE
  @require: stdjabook
  @require: code
  @require: itemize
  @require: math
  @require: base/block
  @require: base/inline

  let lorem = {Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.}
  let lemon = {何故だかその頃私は見すぼらしくて美しいものに強くひきつけられたのを覚えている。風景にしても壊れかかった街だとか、その街にしてもよそよそしい表通りよりもどこか親しみのある、汚い洗濯物が干してあったりがらくたが転がしてあったりむさくるしい部屋が覗いていたりする裏通りが好きであった。}
  let mathexample = {${\\abs{\\mathrm{Orb}_G\\(x\\)} \\cdot \\abs{\\mathrm{Stab}_G\\(x\\)} = \\abs{G}}}

  let make-heading fontname ctx =
    ctx |> set-paragraph-margin 30pt 0pt
        |> set-font-size 14pt
        |> Block.of-inline ?:(true) true false (Inline.of-string fontname)

  let-block ctx +show-math-font name =
    let heading = ctx |> make-heading name
    in
    let example = ctx
      |> set-math-font name
      |> Block.of-inline ?:(true) true true (Inline.read mathexample)
    in
    Block.concat [heading; example]

  let-block ctx +show-cjk-font name =
    let heading = ctx |> make-heading name
    in
    let example = ctx
      |> set-font HanIdeographic (name, 1., 0.)
      |> set-font Kana (name, 1., 0.)
      |> Block.of-inline ?:(true) true true (Inline.read lemon)
    in
    Block.concat [heading; example]

  let-block ctx +show-latin-font name =
    let heading = ctx |> make-heading name
    in
    let example = ctx
      |> set-font Latin (name, 1., 0.)
      |> set-font OtherScript (name, 1., 0.)
      |> Block.of-inline ?:(true) true true (Inline.read lorem)
    in
    Block.concat [heading; example]

  in
  document (|
    title = {\\SATySFi;-fonts-computer-modern};
    author = {Yuito Murase};
    show-title = true;
    show-toc = false;
  |) '<
    <% for font in latin_fonts %>+show-latin-font(`<%= pkgname %>:<%= font['name'] %>`);
    <% end %>
    <% for font in cjk_fonts %>+show-cjk-font(`<%= pkgname %>:<%= font['name'] %>`);
    <% end %>
    <% for font in math_fonts %>+show-math-font(`<%= pkgname %>:<%= font['name'] %>`);
    <% end %>
  >
TEMPLATE

def select_fonts(fonts, type)
  fonts.select { |font| font['type'] == type }
end

def gen_doc_saty(yml)
  pkgname = yml['name']
  cjk_fonts = select_fonts(yml['font-list'], 'cjk')
  latin_fonts = select_fonts(yml['font-list'], 'latin')
  math_fonts = select_fonts(yml['font-list'], 'math')

  ERB.new(DOC_SATY_TEMPLATE)
     .result(binding)
end
