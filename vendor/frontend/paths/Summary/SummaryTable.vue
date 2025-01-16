<script setup>
import { defineProps } from 'vue'
import * as app from '%root/src/app'
import components from '%root/components'
const ui = components.toolkit

defineProps({
  records: Array,
})

const columns = components.toolkit.helpers.useDataTableColumns(
    { id: 'id', caption: 'id' },
    { id: 'task', caption: 'task' },
    { id: 'start', caption: 'start at' },
    { id: 'end', caption: 'end at' },
    { id: 'message', caption: 'message' },
)
</script>
<template>
  <ui.DataTable
    :columns="columns"
    :records="records"
  >
    <template #start="{ record }">
      {{ app.time.format(record.start_at) }}
    </template>
    <template #end="{ record }">
      {{ app.time.format(record.end_at) }}
    </template>
  </ui.DataTable>
</template>
