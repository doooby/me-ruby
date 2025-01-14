<script setup>
import { ref } from 'vue'
import * as app from '%root/src/app'
import rdb from '%root/vendor/recordable'
import components from '%root/src/components'
import { parseISO } from "date-fns";
const ui = components.toolkit

const tasks = ref()

const aa = app.DataReader.useRead({
  payloadMapper: rdb.list(app.tasks.initializeTask),
})
aa.read((value) => {
  console.log('done', value)
})

const initialDataSet = [
  {id:3, task:'me10', start_at:parseISO('2024-12-30 02:15:00'), end_at:parseISO('2024-12-30 05:00:00'), message:'prod setup'},
  {id:5, task:'me13', start_at:parseISO('2025-01-01 02:30:00'), end_at:parseISO('2025-01-01 03:15:00'), message:'revision'},
  {id:6, task:'me13', start_at:parseISO('2025-01-01 03:17:21'), end_at:parseISO('2025-01-01 05:58:00'), message:'revision'},
  {id:8, task:'me13,me6', start_at:parseISO('2025-01-02 04:15:00'), end_at:parseISO('2025-01-02 05:20:00'), message:'better date print'},
  {id:9, task:'me9', start_at:parseISO('2025-01-03 08:01:33'), end_at:parseISO('2025-01-03 09:00:00'), message:'frontend'},
  {id:10, task:'me9', start_at:parseISO('2025-01-04 04:29:54'), end_at:parseISO('2025-01-04 06:37:00'), message:'frontend table'},
  {id:11, task:'me8', start_at:parseISO('2025-01-10 04:00:00'), end_at:parseISO('2025-01-10 05:00:00'), message:null},
  {id:12, task:'me8,me9', start_at:parseISO('2025-01-10 04:54:42'), end_at:parseISO('2025-01-10 05:19:00'), message:'frontend setup, import recordable.js'},
  {id:13, task:'me9', start_at:parseISO('2025-01-10 07:13:08'), end_at:parseISO('2025-01-10 07:40:00'), message:null},
  {id:14, task:'me9', start_at:parseISO('2025-01-11 05:00:00'), end_at:parseISO('2025-01-11 08:00:00'), message:null},
  {id:15, task:null, start_at:parseISO('2025-01-12 06:59:05'), end_at:parseISO('2025-01-12 08:39:00'), message:null},
  {id:16, task:'me9', start_at:parseISO('2025-01-14 03:45:07'), end_at:null, message:null},
]


const tableContext = components.toolkit.helpers.useDataTable(
  [
    { id: 'id', caption: 'id' },
    { id: 'task', caption: 'task' },
    { id: 'start', caption: 'start at' },
    { id: 'end', caption: 'end at' },
    { id: 'message', caption: 'message' },
  ],
  initialDataSet,
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
  <ui.DataTable :context="tableContext">
    <template #start="{ record }">
      {{ components.format.time(record.start_at) }}
    </template>
    <template #end="{ record }">
      {{ components.format.time(record.end_at) }}
    </template>
  </ui.DataTable>
</template>
