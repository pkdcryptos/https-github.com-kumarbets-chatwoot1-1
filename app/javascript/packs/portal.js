import Vue from 'vue';



Vue.config.env = process.env;


Vue.use(VueRouter);

let template = "<div>Hello portal</div>"
window.onload = () => {
  window.WOOT = new Vue({
    template,
  }).$mount('#app');
};


