<template>
  <el-menu mode="horizontal" default-active="activeIndex" menu-trigger="click"
           @select="handleSelect" :router="ifRouter">
    <el-menu-item index="1">Workspace</el-menu-item>
    <el-menu-item index="2">Tasks</el-menu-item>
    <el-menu-item index="3" route="Script">Script</el-menu-item>
    <el-menu-item index="4" route="About">About</el-menu-item>
  </el-menu>
</template>

<script>
  export default {
    data() {
      return {
        activeIndex: 1,
        aboutLink: 'https://www.github.com/ZexuanTHU/llmt/',
        ifRouter: true,
      };
    },
    methods: {
      handleSelect(key, keyPath) {
        console.log(key, keyPath);
      },
    },
  };
</script>
