const { spawn } = require('child_process');
const path = require('path');

const app = spawn('npm', ['start'], {
  stdio: 'inherit',
  env: { ...process.env, NODE_ENV: 'production' }
});

app.on('close', (code) => {
  console.log(`Process exited with code ${code}`);
});
