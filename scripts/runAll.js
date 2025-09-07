/* eslint-disable */
import { spawn } from 'node:child_process';

const variants = ['basic', 'optimized', 'minimal'];
const users = [100, 1000, 5000];

async function run(cmd, env = {}) {
  return new Promise((resolve, reject) => {
    const child = spawn('npx', ['hardhat', 'run', 'scripts/benchmark.ts'], {
      stdio: ['ignore', 'pipe', 'pipe'],
      env: { ...process.env, ...env },
    });
    let out = '';
    child.stdout.on('data', (d) => (out += d.toString()));
    child.stderr.on('data', (d) => (out += d.toString()));
    child.on('close', (code) => {
      if (code === 0) resolve(out);
      else reject(new Error(out));
    });
  });
}

for (const v of variants) {
  for (const u of users) {
    // eslint-disable-next-line no-await-in-loop
    const output = await run('bench', { VARIANT: v, NUM_USERS: String(u) });
    console.log(`[RESULT] variant=${v} users=${u} ->`, output.trim());
  }
}



