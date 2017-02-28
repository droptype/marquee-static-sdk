
runCompilation  = require '../compiler'
startServer     = require './server'
startWatcher    = require './watcher'

module.exports = (project_directory, options) ->
    options._defer_emits = true
    build_directory = runCompilation project_directory, options, (files, assets, project_package, project_config) ->
        host = options.host
        port = parseInt(options.port)
        port = 5000 unless port
        startServer(host, port, build_directory, files._indexed)
        startWatcher(project_directory, build_directory, options, project_config)
