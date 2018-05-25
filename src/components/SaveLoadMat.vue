<template>
  <div>
    <el-container>
      <el-aside width="64px">
        <SideBar/>
      </el-aside>
      <el-container>
        <el-header style="padding: 0px">
          <LHeader/>
        </el-header>
        <el-main>
          <Upload/>
        </el-main>
        <el-footer><LFooter/></el-footer>
      </el-container>
    </el-container>
  </div>
</template>

<script>
  import LHeader from './LHeader';
  import SideBar from './SideBar';
  import LFooter from './LFooter';
  import Upload from './Upload';

  export default {
    name: 'SaveLoadMat',
    components: {
      'SideBar': SideBar,
      'LHeader': LHeader,
      'LFooter': LFooter,
      'Upload': Upload,
    },
  };
</script>
