<template>
  <div>
    <div>
      <el-container style="height: 800px;">
        <el-aside width="65px" style="background: white;">
          <LSide/>
        </el-aside>
        <el-container>
          <el-header style="padding: 0">
            <LHeader/>
          </el-header>
          <el-main style="background: #e4e4e4;">
            <div style="background: white; padding: 10px;">
              <WorkspaceTable></WorkspaceTable>
            </div>
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
  import WorkspaceTable from './basic/WorkspaceTable';

  export default {
    components: {
      LSide, LHeader, LFooter, WorkspaceTable,
    },
  };
</script>
