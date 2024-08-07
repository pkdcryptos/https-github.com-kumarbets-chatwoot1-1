const path = require('path');

const resolve = {
  extensions: ['.js', '.vue'],
  alias: {
    vue$: 'vue/dist/vue.common.js',
    widget: path.resolve('./app/javascript/widget'),
    survey: path.resolve('./app/javascript/survey'),
    helpers: path.resolve('./app/javascript/shared/helpers'),
    './iconfont.eot': 'vue-easytable/libs/font/iconfont.eot',
    './iconfont.woff': 'vue-easytable/libs/font/iconfont.woff',
    './iconfont.ttf': 'vue-easytable/libs/font/iconfont.ttf',
    './iconfont.svg': 'vue-easytable/libs/font/iconfont.svg',
  },
};

module.exports = resolve;
