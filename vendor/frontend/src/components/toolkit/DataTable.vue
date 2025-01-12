<script setup>
import { defineProps } from 'vue'
import components from '%root/src/components'

const props = defineProps({
  context: Object,
})

const context = components.toolkit.helpers.castDataTableContext(props.context)
</script>

<template>
  <table class="table table-hover">
    <colgroup>
      <col
          v-for="(column, index) in context.columns.list"
          :key="column.id"
          :style="context.columns.cssStyles[index]"
        >
    </colgroup>
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
