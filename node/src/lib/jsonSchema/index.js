const Ajv = require('ajv')
const ajv = new Ajv({ schemaId: 'id' }) // we using version 4
ajv.addMetaSchema(require('ajv/lib/refs/json-schema-draft-04.json'))

/**
 *
 * Instantiates the JSON (or part) object as a JSON Schema
 * and compiles it with Ajv
 *
 * @param {object} schema
 */
function JsonSchema (schema) {
  this.schema = schema
  this.validate = ajv.compile(this.schema)
}

/**
 * Validate input against the schema
 *
 * @param {object} input
 * @returns {object} resp { valid: true|false, errors: {}}
 */
JsonSchema.prototype.validateInput = function (input) {
  const valid = this.validate(input)
  const resp = {
    valid: false,
    errors: {}
  }

  if (!valid) resp.errors = this.validate.errors
  else resp.valid = true

  return resp
}

// export the class
module.exports = JsonSchema
