import Vue from 'vue';



Vue.config.env = process.env;


Vue.use(VueRouter);

let template = "<div>Hello v3app</div>"
window.onload = () => {
  window.WOOT = new Vue({
    template,
  }).$mount('#app');
};


