const { spawn } = require('child_process');
const path = require('path');
const fs = require('fs');

// Check if we're in a standalone build environment
const standaloneServerPath = path.join(process.cwd(), '.next/standalone/server.js');
const isStandalone = fs.existsSync(standaloneServerPath);

let app;

if (isStandalone) {
  // For standalone builds, run the standalone server directly
  console.log('Starting standalone Next.js server...');
  app = spawn('node', [standaloneServerPath], {
    stdio: 'inherit',
    env: { 
      ...process.env, 
      NODE_ENV: 'production',
      PORT: process.env.PORT || 3000
    }
  });
} else {
  // For regular builds, use npm start
  console.log('Starting Next.js server with npm...');
  app = spawn('npm', ['start'], {
    stdio: 'inherit',
    env: { ...process.env, NODE_ENV: 'production' }
  });
}

app.on('close', (code) => {
  console.log(`Process exited with code ${code}`);
});
