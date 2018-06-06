<template>
  <div>
  <el-container style="height: 1000px">
    <el-aside width="65px" style="background: white">
      <LSide/>
    </el-aside>
    <el-container>
      <el-header>
        <LHeader/>
      </el-header>
      <el-main style="background-color: #e4e4e4">
        <div style="background: white; padding: 10px;">
          <block-tag tag-name="Load MT Image"></block-tag>
          <el-upload
            class="upload-demo"
            ref="upload"
            action="https://jsonplaceholder.typicode.com/posts/"
            :on-preview="handlePreview"
            :on-remove="handleRemove"
            :file-list="fileList"
            :auto-upload="false">
            <el-button slot="trigger" style="width: 80px;" size="small">
              Select...
            </el-button>
            <el-button style="margin-left: 10px; width: 80px;" size="small"
                       type="success"
                       @click="submitUpload">Load
            </el-button>
            <div slot="tip" class="el-upload__tip">
              Allow .mat file within 500kb size
            </div>
          </el-upload>
        </div>
        <br/>
        <div style="background: white; padding: 10px;">
          <block-tag tag-name="Load MAP Image"></block-tag>
          <el-upload
            class="upload-demo"
            ref="upload"
            action="https://jsonplaceholder.typicode.com/posts/"
            :on-preview="handlePreview"
            :on-remove="handleRemove"
            :file-list="fileList"
            :auto-upload="false">
            <el-button slot="trigger" style="width: 80px;" size="small">
              Select...
            </el-button>
            <el-button style="margin-left: 10px; width: 80px;" size="small"
                       type="success"
                       @click="submitUpload">Load
            </el-button>
            <div slot="tip" class="el-upload__tip">
              Allow .mat file within 500kb size
            </div>
          </el-upload>
        </div>
        <br/>
        <div style="background: white; padding: 10px;">
          <block-tag tag-name="Load MT / MAP Var from Workspace"></block-tag>
          <div>
            <el-transfer
              style="text-align: left; display: inline-block"
              v-model="value3"
              filterable
              filter-placeholder="Search var name here"
              :left-default-checked="[2, 3]"
              :right-default-checked="[1]"
              :render-content="renderFunc"
              :titles="['Source', 'Target']"
              :format="{
                noChecked:'${total}',
                hasChecked:'${checked}/${total}'}"
              @change="handleChange"
              :data="data">
              <el-button class="transfer-footer" slot="right-footer" plain
                         type="danger" size="small">Clear
              </el-button>
              <el-button class="transfer-footer" slot="right-footer"
                         type="success" size="small" @click="varSubmitload">
                Load
              </el-button>
            </el-transfer>
          </div>
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
  import LHeader from './basic/LHeader';
  import LSide from './basic/LSide';
  import LFooter from './basic/LFooter';
  import BlockTag from './basic/BlockTag';


  export default {
    components: {
      LHeader,
      LSide,
      LFooter,
      BlockTag,
    },
    data() {
      const generateData = (_) => {
        const data = [];
        for (let i = 1; i <= 15; i++) {
          data.push({
            key: i,
            label: `MT_Var ${ i }`,
          });
        }
        return data;
      };
      return {
        data: generateData(),
        value3: [1],
        value4: [1],
        renderFunc(h, option) {
          return <span>{ option.key } - { option.label }</span>;
        },
      };
    },
    methods: {
      handleChange(value, direction, movedKeys) {
        console.log(value, direction, movedKeys);
      },
      submitUpload() {
        this.$refs.upload.submit();
        this.$message({
          showClose: true,
          message: 'Load success',
          type: 'success',
        });
      },
      varSubmitload() {
        this.$message({
          showClose: true,
          message: 'Load success',
          type: 'success',
        });
      },
    },
  };
</script>

<style>
  .transfer-footer {
    margin-left: 20px;
    padding: 6px 5px;
  }
</style>
