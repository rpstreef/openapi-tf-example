const openapi2schema = require('openapi2schema')
const fs = require('fs')

// Async with callback
openapi2schema(process.argv[2], { clean: true }, function (err, result) {
  if (err) {
    return console.error(err)
  }

  fs.writeFile(process.argv[3], JSON.stringify(result), function (err) {
    if (err) {
      return console.log(err)
    }
    console.log('The file was saved!')
  })
})
