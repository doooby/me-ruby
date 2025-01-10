<script setup>
defineProps({
  msg: String,
})

</script>

<template>
  <table class="table table-hover">
    <thead>
      <tr>
        <th>id</th>
        <th>task</th>
        <th>start</th>
        <th>end</th>
        <th>message</th>
      </tr>
    </thead>
    <slot />
  </table>
</template>
