module.exports =
  source:
    options:
      bare: yes
    files: [
      expand: yes
      cwd: './src/vendor/wheaton'
      src: ['**/*.coffee']
      dest: './bin'
      ext: '.js'
    ]
