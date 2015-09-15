module.exports =
  source:
    options:
      prefer_english_operator:
        level: 'warn'
      no_empty_param_list:
        level: 'warn'
      arrow_spacing:
        level: 'error'
      max_line_length:
        level: 'ignore'
      indentation:
        level: 'ignore'
    files:
      src: [
        'Gruntfile.coffee'
        '{src,grunt,test}/{,**/}*.coffee'
      ]
