'use strict'

const Enforcer = require('openapi-enforcer')
const path = require('path')

Enforcer(path.resolve(process.argv[2]), { fullResult: true })
  .then(function ({ error, warning }) {
    if (!error) {
      console.log('No errors with your document')
      if (warning) console.warn(warning)
    } else {
      console.error(error)
    }
  })
