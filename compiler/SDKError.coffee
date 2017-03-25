
path    = require 'path'
colors  = require 'colors/safe'
util    = require 'util'

colors.setTheme
    silly     : 'rainbow',
    input     : 'grey',
    verbose   : 'cyan',
    prompt    : 'grey',
    info      : 'green',
    data      : 'grey',
    help      : 'cyan',
    warn      : 'yellow',
    debug     : 'blue',
    error     : 'red'


MAIN = 'http://developer.marquee.by/marquee-static-sdk/'



DOCS =
    main                    : 'compiler/#main'
    configuration           : 'configuration/'
    'configuration.deploy'  : 'configuration/#deployment'
    tokens                  : 'configuration/#tokens'
    emitFile                : 'compiler/#-emitfile-'
    'emitFile.json'         : 'compiler/#-emitfile-'
    'emitFile.path'         : 'compiler/#-emitfile-'
    'project.react'         : 'compiler/#-referenceerror-react-is-not-defined-'
    files                   : ''
    'react-cache.dirty'     : 'compiler/'
    'react-cache.develop'   : 'compiler/'
    assets                  : 'assets/'
    'assets.emitAssets'     : 'assets/#-emitassets-'
    compiler                : 'compiler/'
    'deploy.repo'           : 'compiler/#uncommitted-changes-detected-but-no-changes-apparent'
    api:
        201: 'api/#201-created'
        204: 'api/#204-no-content'
        404: 'api/#404-not-found'
        401: 'api/#401-unauthorized'
        403: 'api/#403-forbidden'
        410: 'api/#410-gone'
        500: 'api/#500-internal-server-error'
        toString: -> 'api/'

for k,v of DOCS
    if typeof v is 'object'
        for _k, _v of v
            unless _k is 'toString'
                v[_k] = "#{ MAIN }#{ _v }"
    else
        unless _k is 'toString'
            DOCS[k] = "#{ MAIN }#{ v }"

SDKError = (subject, message, code=null) ->
    if arguments.length is 1
        return new Error(_prefix + colors.error(subject))
    unless DOCS[subject]
        console.warn(colors.grey("Unknown error subject specified: #{ subject }"))
        return new Error(_prefix + colors.error(message))
    if code and DOCS[subject][code]
        url = DOCS[subject][code]
    else
        url = DOCS[subject]

    if message.stack
        post_message = "\nOriginal stack trace:\n#{ colors.yellow(message.stack) }\n"
    else
        post_message = ''
    return new Error("#{ _prefix }#{ colors.error(message) }\nDocs: #{ colors.underline(colors.help(url)) }\n#{ post_message }")



SDKError.warn = (subject, message, code=null) ->
    if arguments.length is 1
        util.log(_prefix + colors.warn(subject))
        return
    unless DOCS[subject]
        console.warn(colors.warn("Unknown error subject specified: #{ subject }"))
        util.log(_prefix + colors.warn(message))
        return
    if code and DOCS[subject][code]
        url = DOCS[subject][code]
    else
        url = DOCS[subject]
    return util.log("#{ _prefix }#{ colors.warn(message) } Docs: #{ colors.underline(colors.help(url)) }")

SDKError.throw = (subject, message) ->
    util.log("#{ _prefix }#{ colors.error(message) } Docs: #{ colors.underline(colors.help(url)) }")
    process.exit()

SDKError.formatProjectPath = (p, f=null) ->
    p_parent = path.dirname(p) + '/'
    if f
        return "#{ colors.grey.underline(p.replace(p_parent,'')) }#{ colors.green(f.replace(p,'')) }"
    return "#{ colors.grey(p_parent) }#{ colors.green(p.replace(p_parent,'')) }"

_prefix = ''
SDKError.setPrefix = (prefix) -> _prefix = prefix
SDKError.clearPrefix = -> _prefix = ''
SDKError.indent = -> _prefix = '\t'
SDKError.unindent = -> SDKError.clearPrefix()

SDKError.alwaysLog = (message) ->
    util.log("#{ _prefix }#{ message }")
SDKError.log = (message) ->
    if global.VERBOSE
        util.log("#{ _prefix }#{ message }")

SDKError.colors = colors

module.exports = SDKError