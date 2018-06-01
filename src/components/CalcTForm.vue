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
          <div style="padding:0 10px 0 10px; background: white;">
            <el-upload
              class="upload-demo"
              drag
              action="https://jsonplaceholder.typicode.com/posts/"
              multiple>　
              <i class="el-icon-upload"></i>
              <div class="el-upload__text">将文件拖到此处，或<em>点击上传</em></div>
              <div class="el-upload__tip" slot="tip">只能上传jpg/png文件，且不超过500kb
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
    name: 'HomePage',
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

<style>
</style>
