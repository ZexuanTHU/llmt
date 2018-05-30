import Vue from 'vue';
import Element from 'element-ui';
import Router from 'vue-router';
import HomePage from '@/components/HomePage';
import SetUp from '@/components/SetUp';
import SaveLoadMat from '@/components/SaveLoadMat';
import About from '@/components/About';

Vue.use(Router);
Vue.use(Element);

export default new Router({
  routes: [
    {
      path: '/',
      name: 'HomePage',
      component: HomePage,
    },
    {
      path: '/homepage',
      name: 'HomePage',
      component: HomePage,
    },
    {
      path: '/setup',
      name: 'SetUp',
      component: SetUp,
    },
    {
      path: '/saveloadmat',
      name: 'SaveLoadMat',
      component: SaveLoadMat,
    },
    {
      path: '/about',
      name: 'About',
      component: About,
    },
  ],
});
