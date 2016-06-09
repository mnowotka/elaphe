module.exports = (grunt) ->

# configuration
  grunt.initConfig

# grunt coffee
    coffee:
      compile:
        expand: true
        cwd: 'src'
        src: ['**/*.coffee']
        dest: 'assets/js'
        ext: '.js'
        options:
          bare: true
          preserve_dirs: true

    mochaTest:
      test:
        options:
          reporter: 'spec'
          require: 'coffee-script/register'
        src: ['test/**/*.coffee']

# grunt watch (or simply grunt)
    watch:
      html:
        files: ['**/*.html']
      coffee:
        files: '<%= coffee.compile.src %>'
        tasks: ['coffee']
      options:
        livereload: true

    requirejs:
      compile:
        options:
          mainConfigFile: 'assets/js/build.js',
          baseUrl: "assets/js",
          name: "elaphe",
          include: ['build', 'vendor/require.js'],
          out: 'assets/js/elaphe.min.js'




  # load plugins
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-requirejs'
  grunt.loadNpmTasks 'grunt-mocha-test'

  # tasks
  grunt.registerTask 'default', ['coffee', 'watch']
  grunt.registerTask 'test', ['mochaTest']