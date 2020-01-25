const { series, task, dest, src } = require('gulp')
const zip = require('gulp-zip')
const del = require('del')
const install = require('gulp-install')
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

// Set project parameters
const api_post_confirmation_dir = './node/'
const projectName = 'example'
const zipFileName = 'dist-example.zip'
// end project parameters

const distDirectory = './dist'
const fromRootDistDirectory = './env/' + env + '/dist'
const tfvar_file_path = env + '.tfvars'

task('to-root-dir', function () {
  return Promise.resolve(process.chdir('../../'))
})

task('from-root-dir', function () {
  return Promise.resolve(process.chdir('./env/' + env))
})

task('clean-project-layer', function () {
  return del(distDirectory + '/' + projectName + '/*')
    .then(del(distDirectory + '/layer/*'))
})

task('js-project', function () {
  return src([api_post_confirmation_dir + 'src/**/*'])
    .pipe(dest(fromRootDistDirectory + '/' + projectName + '/'))
})

task('js-layer-project', function () {
  return src([api_post_confirmation_dir + 'package.json'])
    .pipe(dest(fromRootDistDirectory + '/layer/nodejs'))
})

task('npm-project-layer', function () {
  return src(api_post_confirmation_dir + 'package.json')
    .pipe(dest(fromRootDistDirectory + '/layer/nodejs'))
    .pipe(install({ production: true }))
})

// nodir, dot added to make sure node modules are zipped correctly!
task('zip-project', function () {
  return src([distDirectory + '/' + projectName + '/**/*', '!' + distDirectory + '/' + projectName + '/package.json', distDirectory + '/' + projectName + '/.*'], { nodir: true, dot: true })
    .pipe(zip(zipFileName))
    .pipe(dest(distDirectory))
})

task('zip-layer-project', function () {
  return src(['' + distDirectory + '/layer/**/*', '!' + distDirectory + '/layer/nodejs/package.json', '' + distDirectory + '/layer/.*'], { nodir: true, dot: true })
    .pipe(zip('dist-layer.zip'))
    .pipe(dest(distDirectory))
})

task('terraform', function () {
  return new Promise(
    shell.task([
      'terraform fmt',
      'terraform workspace select ' + env,
      'terraform validate',
      'terraform apply -var-file="' + tfvar_file_path + '"'
    ])
  )
})

task('terraform-init', function () {
  return new Promise(
    shell.task([
      'terraform init',
      'terraform workspace new ' + env
    ])
  )
})

task('format', function () {
  return new Promise(
    shell.task([
      'standard --fix'
    ])
  )
})

exports.build = task('full',
  series(
    task('clean-project-layer'),
    task('to-root-dir'),
    task('js-project'),
    task('js-layer-project'),
    task('npm-project-layer'),
    task('from-root-dir'),
    task('zip-project'),
    task('zip-layer-project'),
    task('terraform')
  ))

exports.build = task('src',
  series(
    task('clean-project-layer'),
    task('js-project'),
    task('zip-project'),
    task('terraform')
  ))

exports.build = task('infra',
  series(
    task('terraform')
  ))

exports.build = task('init',
  series(
    task('terraform-init')
  ))
