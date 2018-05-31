<template>
  <div>
    <el-container style="height: 800px">
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
                <el-steps :active="active" finish-status="success">
                  <el-step title="Scale"></el-step>
                  <el-step title="Interval"></el-step>
                  <el-step title="Check Config"></el-step>
                </el-steps>
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
                  <el-table
                    :data="states"
                    v-else
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
                </span>
                <span v-if="this.active===0">nm/pixel</span>
                <span v-else-if="this.active===1">num</span>
                <span v-else></span>
                <br/>
                <el-button v-if="active<=2" style="margin-top: 12px;"
                           @click="next">
                  <span v-if="active===0 || active===1">Next</span>
                  <span v-else-if="active===2">Save</span>
                </el-button>
              </el-col>
            </el-row>
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
  import SideBar from './LSide';
  import LFooter from './LFooter';

  export default {
    name: 'SetUp',
    components: {
      'SideBar': SideBar,
      'LHeader': LHeader,
      'LFooter': LFooter,
    },
    data() {
      return {
        restaurants: [],
        state: '',
        active: 0,
        states: [
          {name: 'Scale', value: ''},
          {name: 'Interval', value: ''},
        ],
      };
    },
    methods: {
      next() {
        if (this.active !== 2 && this.state !== '') {
          console.log(this.state);
          this.states[this.active].value = this.state;
          this.active++;
        } else {
          this.active++;
          this.$message({
            showClose: true,
            message: 'Your configuration already saved!',
            type: 'success',
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
