import Vue from 'vue';
import Element from 'element-ui';
import Router from 'vue-router';
import HomePage from '@/components/HomePage';
import SetUp from '@/components/SetUp';
import SaveLoadMat from '@/components/SaveLoadMat';
import Tasks from '@/components/Tasks';
import About from '@/components/About';
import Script from '@/components/Script';

Vue.use(Router);
Vue.use(Element);

export default new Router({
  routes: [
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
      path: '/tasks',
      name: 'Tasks',
      component: Tasks,
    },
    {
      path: '/script',
      name: 'Script',
      component: Script,
    },
    {
      path: '/about',
      name: 'About',
      component: About,
    },
  ],
});
