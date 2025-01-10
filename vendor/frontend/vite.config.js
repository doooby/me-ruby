import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

// https://vite.dev/config/
export default defineConfig({
  plugins: [vue()],
  server: {
    hmr: true,
    port: 3031,
  },
  resolve: {
    alias: {
        '%root/': '/',
    },
},
})
