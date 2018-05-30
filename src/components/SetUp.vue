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
                <el-autocomplete
                  class="inline-input"
                  v-model="state1"
                  :fetch-suggestions="querySearch"
                  placeholder="请输入内容"
                  @select="handleSelect"
                >
                </el-autocomplete>
                <div v-if="this.active===0">nm/pixel</div>
                <div v-else-if="this.active===1">num</div>
                <div v-else></div>
                <br/>
                <el-button style="margin-top: 12px;" @click="next">Save
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
        state1: '',
        active: 0,
      };
    },
    methods: {
      next() {
        if (this.state1 !== '') {
          this.active++;
        }
        // if (this.active++ > 2) this.active = 0;
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
