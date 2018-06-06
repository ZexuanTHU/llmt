<template>
  <div>
    <el-container style="height: 1000px;">
      <el-aside width="65px" style="background: white">
        <LSide/>
      </el-aside>
      <el-container>
        <el-header>
          <LHeader></LHeader>
        </el-header>
        <el-main style="background-color: #e4e4e4">
          This software was developed by Shian@Liang Lab
        </el-main>
        <el-footer style="background-color: #e4e4e4">
          <LFooter/>
        </el-footer>
      </el-container>
    </el-container>
  </div>
</template>

<script>
  import LSide from './basic/LSide';
  import LHeader from './basic/LHeader';
  import LFooter from './basic/LFooter';

  export default {
    name: 'About',
    components: {LSide, LHeader, LFooter},
  };
</script>
