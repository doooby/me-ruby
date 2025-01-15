<script setup>
import { ref } from 'vue'
import * as app from '%root/src/app'
import rdb from '%root/vendor/recordable'
import components from '%root/src/components'
const ui = components.toolkit

const { stateRef: previousDataState, reader: dataReader } = app.DataReader.useCached(
  new app.DataReader({
    payloadMapper: rdb.list(app.tasks.initializeTask),
  })
)
dataReader.read()

const columns = components.toolkit.helpers.useDataTableColumns(
    { id: 'id', caption: 'id' },
    { id: 'task', caption: 'task' },
    { id: 'start', caption: 'start at' },
    { id: 'end', caption: 'end at' },
    { id: 'message', caption: 'message' },
)

// const dataReader = new app.DataReader({
//   payloadMapper: rdb.list(app.tasks.initializeTask),
// })
// const dataReaderState = ref(dataReader.state)
// dataReader.onChange = (newState) => {
//   dataReaderState.value = newState
// }
// dataReader.read().then(
//   () => tasks.value = dataReaderState.value.record
// )


</script>

<template>
  <ui.DataTable
    :columns="columns"
    :records="previousDataState.record"
  >
    <template #start="{ record }">
      {{ components.format.time(record.start_at) }}
    </template>
    <template #end="{ record }">
      {{ components.format.time(record.end_at) }}
    </template>
  </ui.DataTable>
</template>
