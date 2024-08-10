const path = require('path');

const resolve = {
  extensions: ['.js', '.vue'],
  alias: {
    vue$: 'vue/dist/vue.common.js',
    './iconfont.eot': 'vue-easytable/libs/font/iconfont.eot',
    './iconfont.woff': 'vue-easytable/libs/font/iconfont.woff',
    './iconfont.ttf': 'vue-easytable/libs/font/iconfont.ttf',
    './iconfont.svg': 'vue-easytable/libs/font/iconfont.svg',
  },
};

module.exports = resolve;
