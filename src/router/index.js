import Vue from 'vue';
import Element from 'element-ui';
import Router from 'vue-router';
import HomePage from '@/components/HomePage';
import SetUp from '@/components/SetUp';
import SaveLoadMat from '@/components/SaveLoadMat';
import Workspace from '@/components/Workspace';
import Tasks from '@/components/Tasks';
import About from '@/components/About';
import Script from '@/components/Script';
import LoadImages from '@/components/LoadImages';
import CalcTForm from '@/components/CalcTForm';
import AddMTLine from '@/components/AddMTLine';
import AddKymograph from '@/components/AddKymograph';
import CalcMTEnd from '@/components/CalcMTEnd';

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
      path: '/workspace',
      name: 'Workspace',
      component: Workspace,
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
      path: '/loadimages',
      name: 'LoadImages',
      component: LoadImages,
    },
    {
      path: '/calctform',
      name: 'CalcTForm',
      component: CalcTForm,
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
    {
      path: '/addmtline',
      name: 'AddMTLine',
      component: AddMTLine,
    },
    {
      path: '/addkymograph',
      name: 'AddKymograph',
      component: AddKymograph,
    },
    {
      path: '/calcmtend',
      name: 'CalcMTEnd',
      component: CalcMTEnd,
    },
  ],
});
