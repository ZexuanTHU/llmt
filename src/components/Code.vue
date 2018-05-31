<template>
  <codemirror :options="{
    mode: 'javascript',
    extraKeys: {'Ctrl-Space': 'autocomplete'}
  }"></codemirror>
</template>

<script>
  import {codemirror} from 'vue-codemirror-lite';

  require('codemirror/mode/javascript/javascript');
  require('codemirror/mode/vue/vue');

  require('codemirror/addon/hint/show-hint.js');
  require('codemirror/addon/hint/show-hint.css');
  require('codemirror/addon/hint/javascript-hint.js');
  export default {
    data() {
      return {
        code: 'const str = "hello world"',
      };
    },
    computed: {
      editor() {
        // get current editor object
        return this.$refs.myEditor.editor;
      },
    },
    mounted() {
      // use editor object...
      this.editor.focus();
      console.log('this is current editor object', this.editor);
    },
  };
</script>
