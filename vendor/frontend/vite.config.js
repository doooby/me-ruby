import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import vueDevtools from 'vite-plugin-vue-devtools'

// https://vite.dev/config/
export default defineConfig({
  plugins: [
    vue(),
    vueDevtools(),
  ],
  server: {
    hmr: true,
    port: 3031,
  },
  resolve: {
    alias: {
        '%root/': '/',
    },
  },
  define: {
    'import.meta.env.ME_SERVER_ORIGIN': JSON.stringify(
      process.env.ME_SERVER_ORIGIN || 'http://localhost:3030'
    ),
  },
  build: {
    outDir: '../../app/assets/builds',
    rollupOptions: {
      input: './src/main.js',
      output: {
        entryFileNames: 'app.js',
      },
    },
  },
})
