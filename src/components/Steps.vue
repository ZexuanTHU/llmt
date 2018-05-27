<template>
  <div>
    <el-steps :active="active" finish-status="success">
      <el-step title="Scale"></el-step>
      <el-step title="Interval"></el-step>
      <el-step title="Check Config"></el-step>
    </el-steps>
    <el-button style="margin-top: 12px;" @click="next">Save</el-button>
  </div>
</template>

<script>
  export default {
    data() {
      return {
        active: 0,
      };
    },

    methods: {
      next() {
        if (this.active++ > 2) this.active = 0;
      },
    },
  };
</script>
