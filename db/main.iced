config = require '../config'

module.exports = main = (require 'mongoskin').db config.dburi, (safe: true)

main.bind 'templates'
