import path from 'path';
import { defineConfig } from 'vitest/config';
import Vue2 from '@vitejs/plugin-vue2';

export default defineConfig({
  plugins: [Vue2()],
  test: {
    environment: 'jsdom',
    include: ['app/**/*.{test,spec}.?(c|m)[jt]s?(x)'],
    coverage: {
      reporter: ['lcov', 'text'],
      include: ['app/**/*.js', 'app/**/*.vue'],
      exclude: [
        'app/**/*.@(spec|stories|routes).js',
        '**/specs/**/*',
        '**/i18n/**/*',
      ],
    },
    globals: true,
    outputFile: 'coverage/sonar-report.xml',
    server: {
      deps: {
        inline: ['tinykeys', '@material/mwc-icon'],
      },
    },
    setupFiles: ['fake-indexeddb/auto'],
    mockReset: true,
    clearMocks: true,
  },
  resolve: {
    alias: {
    },
  },
});
