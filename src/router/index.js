import Vue from 'vue';
import Element from 'element-ui';
import Router from 'vue-router';
import SideBar from '@/components/SideBar';
import SetUp from '@/components/SetUp';

Vue.use(Router);
Vue.use(Element);

export default new Router({
  routes: [
    {
      path: '/',
      name: 'SideBar',
      component: SideBar,
    },
    {
      path: '/setup',
      name: 'SetUp',
      component: SetUp,
    },
  ],
});
