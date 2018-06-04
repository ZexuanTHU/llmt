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
              <el-table
                :data="workspaceData"
                stripe
              >
                <el-table-column
                  prop="name"
                  label="name">
                </el-table-column>
                <el-table-column
                  prop="value"
                  label="value">
                </el-table-column>
                <el-table-column
                  fixed="right"
                  label="操作"
                  width="100">
                  <template slot-scope="scope">
                    <el-button @click="dialogVisible = true" type="text"
                               size="small">查看
                    </el-button>
                    <el-dialog
                      title="提示"
                      :visible.sync="dialogVisible"
                      width="30%"
                      :before-close="handleClose">
                      <span>这是一段信息</span>
                      <span slot="footer" class="dialog-footer">
                        <el-button
                          @click="dialogVisible = false">取 消</el-button>
                        <el-button type="primary"
                                   @click="dialogVisible = false">确 定
                        </el-button>
                      </span>
                    </el-dialog>
                  </template>
                </el-table-column>
              </el-table>
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

  export default {
    methods: {
      handleClick(row) {
        console.log(row);
      },
      handleClose(done) {
        this.$confirm('确认关闭？')
          .then((_) => {
            done();
          })
          .catch((_) => {
          });
      },
    },
    data() {
      return {
        dialogVisible: false,
        workspaceData: [
          {name: 'var1', value: 'val1'},
          {name: 'var1', value: 'val2'},
        ],
      };
    },
    components: {
      LSide, LHeader, LFooter,
    },
  };
</script>
