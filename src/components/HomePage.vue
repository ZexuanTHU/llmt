<template>
  <div>
    <el-container style="height: 800px">
      <el-aside width="65px" style="background: white">
        <SideBar/>
      </el-aside>
      <el-container>
        <el-header style="padding: 0px">
          <LHeader/>
        </el-header>
        <el-main style="background-color: #e4e4e4">
          <div align="center">
          <img src="../assets/llmt2.png"/>
          </div>
        </el-main>
        <el-footer style="background: #e4e4e4">
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
