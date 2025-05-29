module.exports = {
  apps: [{
    name: 'pmdevop',
    script: '.next/standalone/server.js',
    cwd: '/var/www/domains/pmdevop.com/public_html',
    env: {
      NODE_ENV: 'production',
      PORT: 3000
    }
  }]
}
