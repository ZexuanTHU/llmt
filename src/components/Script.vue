<template>
  <div>
    <div>
      <el-container style="height: 800px;">
        <el-aside width="65px" style="background: white;">
          <LSide/>
        </el-aside>
        <el-container>
          <el-header style="padding: 0px">
            <LHeader/>
          </el-header>
          <el-main style="background: #e4e4e4;">
            <!--<codemirror-->
              <!--:options="{-->
              <!--mode: 'javascript',-->
              <!--extraKeys: {'Ctrl-Space': 'autocomplete'}}">-->
            <!--</codemirror>-->
            <codemirror></codemirror>
          </el-main>
          <el-footer style="background: #e4e4e4;">
            <LFooter/>
          </el-footer>
        </el-container>
      </el-container>
    </div>
  </div>
</template>

<script>
  import LSide from './LSide';
  import LHeader from './LHeader';
  import LFooter from './LFooter';
  import {codemirror} from 'vue-codemirror-lite';

  require('codemirror/mode/javascript/javascript');
  require('codemirror/mode/vue/vue');

  require('codemirror/addon/hint/show-hint.js');
  require('codemirror/addon/hint/show-hint.css');
  require('codemirror/addon/hint/javascript-hint.js');
  export default {
    components: {
      LSide, LHeader, LFooter, codemirror,
    },
  };
</script>

<style>
.CodeMirror-scroll {
  height: 700px;
}

.CodeMirror.cm-s-default.CodeMirror-wrap {
  height: 700px;
}
</style>
