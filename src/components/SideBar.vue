<template>
  <el-row class="tac">
    <el-col :span="12">
      <el-menu
        collapse="true"
        default-active="2"
        class="el-menu-vertical-demo"
        @open="handleOpen"
        @close="handleClose"
        router="true">
        <el-menu-item index="0" route="HomePage">
          <i class="el-icon-llmt-home"></i>
          <span slot="title">LLMT</span>
        </el-menu-item>
        <el-submenu index="1">
          <template slot="title">
            <i class="el-icon-rank"></i>
            <span>MT Workflow</span>
          </template>
          <el-menu-item-group>
            <template slot="title">Pre Settings</template>
            <el-menu-item index="1-1" route="SetUp">
              <i class="el-icon-setting"></i>
              Set Up
            </el-menu-item>
            <el-menu-item index="1-2" route="SaveLoadMat">
              <i class="el-icon-document"></i>
              Load/Save .mat
            </el-menu-item>
            <el-menu-item index="1-3">
              <i class="el-icon-upload2"/>
              Load Images
            </el-menu-item>
          </el-menu-item-group>
          <el-menu-item-group title="MT Toolkit">
            <el-menu-item index="1-3">Calc TForm</el-menu-item>
          </el-menu-item-group>
          <el-submenu index="1-4">
            <template slot="title">Red Value</template>
            <el-menu-item index="1-4-1">Correct Red</el-menu-item>
            <el-menu-item index="1-4-2">Inv Corr Red</el-menu-item>
          </el-submenu>
          <el-menu-item index="1-5">Correct Drift</el-menu-item>
          <el-menu-item index="1-6">Add MT Line</el-menu-item>
          <el-menu-item index="1-7">Calc MT End</el-menu-item>
          <el-menu-item index="1-8">Add Kymorgraph</el-menu-item>
          <el-submenu index="1-9">
            <template slot="title">Analysis</template>
            <el-menu-item index="1-9-1">Analysis</el-menu-item>
            <el-menu-item index="1-9-2">Other Analysis</el-menu-item>
          </el-submenu>
        </el-submenu>
        <el-menu-item index="2">
          <i class="el-icon-menu"></i>
          <span slot="title">导航二</span>
        </el-menu-item>
        <el-menu-item index="3" disabled>
          <i class="el-icon-document"></i>
          <span slot="title">导航三</span>
        </el-menu-item>
        <el-menu-item index="4">
          <i class="el-icon-setting"></i>
          <span slot="title">导航四</span>
        </el-menu-item>
        <el-menu-item index="5">
          <i class="el-icon-setting"></i>
          <span slot="title">导航四</span>
        </el-menu-item>
        <el-menu-item index="6">
          <i class="el-icon-setting"></i>
          <span slot="title">导航四</span>
        </el-menu-item>
        <el-menu-item index="7">
          <i class="el-icon-setting"></i>
          <span slot="title">导航四</span>
        </el-menu-item>
      </el-menu>
    </el-col>
  </el-row>
</template>

<script>
  export default {
    methods: {
      handleOpen(key, keyPath) {
        console.log(key, keyPath);
      },
      handleClose(key, keyPath) {
        console.log(key, keyPath);
      },
    },
  };
</script>

<style>
  @import "../assets/icon/iconfont.css";
</style>
