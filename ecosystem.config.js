module.exports = {
  apps: [{
    name: 'pmdevop',
    script: 'npm',
    args: 'start',
    cwd: '/var/www/domains/pmdevop.com/public_html',
    env: {
      NODE_ENV: 'production',
      PORT: 3000
    }
  }]
}
