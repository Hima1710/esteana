import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  base: './', // مسارات نسبية ليعمل التطبيق من file:// (أوفلاين داخل الأندرويد) ومن Vercel
  server: { port: 8081 },
})
