import {ref} from 'vue'
import rdb from '%root/vendor/recordable'

export default class DataReader extends rdb.RecordReader {

  static useRead(options) {
    const reader = new DataReader({...options})
  const state = ref(reader.state)
    reader.onChange = (newState) => {
      state.value = newState
    }
    async function read () {
      await reader.read()
      return state.value
    }
    return { state, read }
  }

  async fetch () {
    return {
      payload: [
        {
          id: 2,
          task: 'aaa',
        },
        {
          id: 3,
          task: '3bb',
        },
        {
          id: 4,
          task: '4c',
        },
      ],
    }
  }
}
