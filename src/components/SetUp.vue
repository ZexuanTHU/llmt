<template>
  <div>
    <el-container style="height: 1000px">
      <el-aside width="65px">
        <SideBar/>
      </el-aside>
      <el-container>
        <el-header>
          <LHeader/>
        </el-header>
        <el-main style="background-color: #e4e4e4; ">
          <div style="background: white; padding: 10px;">
            <el-row class="demo-autocomplete">
              <el-col :span="12">
                <BlockTag tag-name="Global Parameters Settings"></BlockTag>
                <el-steps :active="active" finish-status="success">
                  <el-step title="Set Scale"></el-step>
                  <el-step title="Set Time Interval"></el-step>
                  <el-step title="Check Configuration"></el-step>
                </el-steps>
                <br/>
                <div class="sub-title"></div>
                <span>
                  <el-autocomplete
                    class="inline-input"
                    v-model="state"
                    :fetch-suggestions="querySearch"
                    placeholder="Please input here"
                    @select="handleSelect"
                    v-if="active===0 || active===1"
                  >
                  </el-autocomplete>
                  <template v-else>
                    <span v-if="active===2">
                      <el-tag>Please check your configuration before saving
                      </el-tag>
                    </span>
                    <el-table
                      :data="states"
                    >
                    <el-table-column
                      prop="name"
                      label="name"
                    >
                    </el-table-column>
                    <el-table-column
                      prop="value"
                      label="value"
                    >
                    </el-table-column>
                  </el-table>
                  </template>
                </span>
                <span v-if="this.active===0">nm/pixel</span>
                <span v-else-if="this.active===1">s</span>
                <span v-else></span>
                <br/>
                <el-button v-if="active<=3"
                           style="margin-top: 12px;"
                           @click="next">
                  <span v-if="active===0 || active===1">Next</span>
                  <span v-else-if="active===2">Save</span>
                  <span v-else-if="active===3">Reset</span>
                </el-button>
              </el-col>
            </el-row>
          </div>
          <br/>
          <div style="background: white; padding: 10px;">
            <block-tag tag-name="Current Parameters"></block-tag>
            <el-table
              :data="states"
            >
              <el-table-column
                prop="name"
                label="name"
              >
              </el-table-column>
              <el-table-column
                prop="value"
                label="value"
              >
              </el-table-column>
              <el-table-column
                prop="units"
                label="units"
              >
              </el-table-column>
            </el-table>
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
  import SideBar from './basic/LSide';
  import LFooter from './basic/LFooter';
  import BlockTag from './basic/BlockTag';

  export default {
    name: 'SetUp',
    components: {
      'SideBar': SideBar,
      'LHeader': LHeader,
      'LFooter': LFooter,
      'BlockTag': BlockTag,
    },
    data() {
      return {
        restaurants: [],
        state: '',
        active: 0,
        states: [
          {name: 'Scale', value: '1', units: 'nm/pixel'},
          {name: 'Time Interval', value: '1', units: 's'},
        ],
      };
    },
    methods: {
      next() {
        if (this.active <= 1) {
          if (this.state === '') {
            this.$message({
              showCLose: true,
              message: 'You cannot skip this step',
              type: 'error',
            });
          } else {
            console.log(this.state, this.active);
            this.states[this.active].value = this.state;
            this.active++;
          }
        } else if (this.active === 2) {
          this.active++;
          this.$message({
            showClose: true,
            message: 'Your configuration already saved!',
            type: 'success',
          });
        } else {
          this.active = 0;
          this.$message({
            showClose: true,
            message: 'Please reset your configuration!',
          });
        }
      },
      querySearch(queryString, cb) {
        let restaurants = this.restaurants;
        let results = queryString ?
          restaurants.filter(this.createFilter(queryString)) : restaurants;
        // 调用 callback 返回建议列表的数据
        cb(results);
      },
      createFilter(queryString) {
        return (restaurant) => {
// eslint-disable-next-line max-len
          return (restaurant.value.toLowerCase().indexOf(queryString.toLowerCase()) === 0);
        };
      },
      loadAll() {
        return [
          {'value': '100', 'address': ''},
          {'value': '200', 'address': ''},
        ];
      },
      handleSelect(item) {
        console.log(item);
      },
    },
    mounted() {
      this.restaurants = this.loadAll();
    },
  };
</script>
