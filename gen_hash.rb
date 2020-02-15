# frozen_string_literal: true

def gen_hash_string(pkgname, fonts)
  content = fonts
            .map do |font|
              "\"#{pkgname}:#{font['name']}\" : " \
                "<Single: {\"src\": \"dist/fonts/#{pkgname}/#{font['file']}\"}>"
            end
            .join ",\n  "

  "{\n  #{content}\n}\n"
end

def gen_fonts_hash(yml)
  fonts = yml['font-list'].select do |font|
    %w[latin cjk].include? font['type']
  end

  gen_hash_string(yml['name'], fonts)
end

def gen_mathfonts_hash(yml)
  fonts = yml['font-list'].select do |font|
    font['type'] == 'math'
  end

  gen_hash_string(yml['name'], fonts)
end