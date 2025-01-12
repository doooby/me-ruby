<script setup>
import { ref } from 'vue'
import * as app from '%root/src/app'
import rdb from '%root/vendor/recordable'
import components from '%root/src/components'
const ui = components.toolkit

const tasks = ref()

const aa = app.DataReader.useRead({
  payloadMapper: rdb.list(app.tasks.initializeTask),
})
aa.read((value) => {
  console.log('done', value)
})

const tableContext = components.toolkit.helpers.useDataTable(
  [
    { id: 'aa', caption: 'sloupec 1' },
    { id: 'ab', caption: 'sloupec 2' },
    { id: 'ac', caption: 'sloupec 3' },
  ]
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
    <tbody>
      <tr>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
      </tr>
      <tr v-for="task in tasks">
        <td>{{ task.id }}</td>
        <td>{{ task.task }}</td>
      </tr>
    </tbody>
  </ui.DataTable>
</template>
