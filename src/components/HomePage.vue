<template>
  <div>
    <el-container>
      <el-aside width="65px">
        <SideBar/>
      </el-aside>
      <el-container>
        <el-header style="padding: 0px">
          <LHeader/>
        </el-header>
        <el-main style="background: white">
          This is HomePage
        </el-main>
        <el-footer style="background: white">
          <LFooter/>
        </el-footer>
      </el-container>
    </el-container>
  </div>
</template>

<script>
  import LHeader from './LHeader';
  import SideBar from './SideBar';
  import LFooter from './LFooter';

  export default {
    name: 'HomePage',
    components: {
      'SideBar': SideBar,
      'LHeader': LHeader,
      'LFooter': LFooter,
    },
  };
</script>

<style>
</style>
