# Portfolio Deployment Guide

## Prerequisites

- Node.js 20.x or later
- PM2 (`npm install -g pm2`)
- Nginx
- Git
- SSH access to your VPS

## Environment Variables

The following environment variables need to be set up in your VPS:

- `NEXT_PUBLIC_CONTACT_PHONE`
- `NEXT_PUBLIC_CONTACT_EMAIL`
- `NEXT_PUBLIC_GITHUB_USERNAME`

## GitHub Secrets

Set up the following secrets in your GitHub repository:

- `DEPLOY_HOST`: Your VPS IP or domain
- `DEPLOY_USER`: SSH user for deployment
- `DEPLOY_PATH`: Path to deploy the application (e.g., /var/www/portfolio)
- `SSH_PRIVATE_KEY`: SSH private key for authentication
- `KNOWN_HOSTS`: SSH known hosts file content
- All environment variables mentioned above

## Manual Deployment Steps

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd portfolio
   ```

2. Install dependencies:
   ```bash
   npm ci
   ```

3. Build the application:
   ```bash
   npm run build
   ```

4. Start the application with PM2:
   ```bash
   pm2 start ecosystem.config.json
   ```

## Nginx Setup

1. Copy the Nginx configuration:
   ```bash
   sudo cp nginx/portfolio.conf /etc/nginx/sites-available/portfolio
   sudo ln -s /etc/nginx/sites-available/portfolio /etc/nginx/sites-enabled/
   ```

2. Test and reload Nginx:
   ```bash
   sudo nginx -t
   sudo systemctl reload nginx
   ```

## SSL Setup (Let's Encrypt)

1. Install Certbot:
   ```bash
   sudo apt install certbot python3-certbot-nginx
   ```

2. Obtain SSL certificate:
   ```bash
   sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com
   ```

## Monitoring

- View logs: `npm run logs`
- Monitor application: `npm run monitor`
- Health check endpoint: `http://yourdomain.com/api/health`

## Troubleshooting

1. If the application fails to start, check:
   - PM2 logs: `pm2 logs portfolio`
   - Nginx error logs: `sudo tail -f /var/log/nginx/error.log`

2. If environment variables are not working:
   - Check if .env file exists
   - Run the update-env.sh script
   - Restart the application: `pm2 restart portfolio`

## Backup

Regular backups are recommended:
- Database (if applicable)
- Environment variables
- Uploaded content
- SSL certificates
