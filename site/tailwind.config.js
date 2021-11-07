const noProse = {
  'pre': null,
  'pre code::before': null,
  'pre code::after': null,
  'code': null,
  'code::before': null,
  'code::after': null,
};


module.exports = {
  purge: [
    './_includes/**/*.html',
    './_layouts/**/*.html',
    './_posts/*.md',
    './*.html',
    './*.md',
    './assets/css/*.scss',
  ],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {
      typography: {
        DEFAULT: {
          css: {
            ...noProse,
          },
        },
        xl: {
          css: {
            ...noProse,
          },
        },
        '2xl': {
          css: {
            ...noProse,
          },
        },
      },
      colors: {
        transparent: 'transparent',
        current: 'currentColor',
        'california': {
          DEFAULT: '#F09E05',
          '50': '#FEF2DC',
          '100': '#FEE9C3',
          '200': '#FDD791',
          '300': '#FCC55F',
          '400': '#FBB32D',
          '500': '#F09E05',
          '600': '#BE7D04',
          '700': '#8C5C03',
          '800': '#5A3B02',
          '900': '#281A01'
        },
      },
    },
  },
  variants: {
    extend: {},
  },
  plugins: [
    require('@tailwindcss/typography'),
  ],
}
