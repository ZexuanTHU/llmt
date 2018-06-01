<template>
  <div>
    <el-container style="height: 800px">
      <el-aside width="65px" style="background: white">
        <LSide/>
      </el-aside>
      <el-container>
        <el-header>
          <LHeader/>
        </el-header>
        <el-main style="background-color: #e4e4e4">
          <div style="background: white; padding: 10px;">
            <el-steps :active="active" finish-status="success">
              <el-step title="Load MT File"></el-step>
              <el-step title="Load MAP File"></el-step>
              <el-step title="Set MT Var"></el-step>
              <el-step title="Set MAP Var"></el-step>
            </el-steps>
            <br/>
            <el-upload
              class="upload-demo"
              drag
              :before-upload="beforeUpload"
              action="https://jsonplaceholder.typicode.com/posts/"
              multiple>
              <i class="el-icon-upload"></i>
              <div class="el-upload__text">Drag MT file here，or<em> Click here
                to upload</em></div>
              <div class="el-upload__tip" slot="tip">Please load MT file within
                500kb size
              </div>
            </el-upload>
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
  import LSide from './LSide';
  import LFooter from './LFooter';


  export default {
    data() {
      return {};
    },
    components: {
      LSide,
      LHeader,
      LFooter,
    },
    methods: {},
  };
</script>
