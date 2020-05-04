const { series, task } = require('gulp')
const shell = require('gulp-shell')
const minimist = require('minimist')

const knownOptions = {
  string: 'env',
  default: { env: process.env.ENV || 'dev' }
}

// get environment and set working directory
const options = minimist(process.argv.slice(2), knownOptions)
const env = options.env
process.chdir('./env/' + env)

const tfvarFilePath = env + '.tfvars'

task('terraform', series(
  shell.task([
    'terraform fmt',
    'terraform workspace select ' + env,
    'terraform validate',
    'terraform apply -var-file="' + tfvarFilePath + '"'
  ]))
)

task('terraform-init', series(
  shell.task([
    'terraform init',
    'terraform workspace new ' + env
  ]))
)

exports.build = task('infra',
  series(
    task('terraform')
  ))

exports.build = task('init',
  series(
    task('terraform-init')
  ))
