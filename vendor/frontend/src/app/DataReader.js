import {ref} from 'vue'
import rdb from '%root/vendor/recordable'
import * as app from '%root/src/app'

export default class DataReader extends rdb.FetchJsonRecordReader {
  stateRef = null

  constructor (options) {
    options.baseUrlPath = `${app.env.serverUrl}/fe-api-v1/`
    super(options)
    this.stateRef = ref(Object.freeze(this.state))
    this.onChange = (newState) => {
      this.stateRef.value = Object.freeze(newState)
    }
  }

  static useCached (reader) {
    const stateRef = ref(reader.stateRef.value)
    const origRead = reader.read
    reader.read = async () => {
      await origRead.call(reader)
      stateRef.value = reader.state
    }
    return { stateRef, reader }
  }

  // async fetch () {
  //   return {
  //     payload: [
  //       {id:3, task:'me10', start_at:'2024-12-30 02:15:00', end_at:'2024-12-30 05:00:00', message:'prod setup'},
  //       {id:5, task:'me13', start_at:'2025-01-01 02:30:00', end_at:'2025-01-01 03:15:00', message:'revision'},
  //       {id:6, task:'me13', start_at:'2025-01-01 03:17:21', end_at:'2025-01-01 05:58:00', message:'revision'},
  //       {id:8, task:'me13,me6', start_at:'2025-01-02 04:15:00', end_at:'2025-01-02 05:20:00', message:'better date print'},
  //       {id:9, task:'me9', start_at:'2025-01-03 08:01:33', end_at:'2025-01-03 09:00:00', message:'frontend'},
  //       {id:10, task:'me9', start_at:'2025-01-04 04:29:54', end_at:'2025-01-04 06:37:00', message:'frontend table'},
  //       {id:11, task:'me8', start_at:'2025-01-10 04:00:00', end_at:'2025-01-10 05:00:00', message:null},
  //       {id:12, task:'me8,me9', start_at:'2025-01-10 04:54:42', end_at:'2025-01-10 05:19:00', message:'frontend setup, import recordable.js'},
  //       {id:13, task:'me9', start_at:'2025-01-10 07:13:08', end_at:'2025-01-10 07:40:00', message:null},
  //       {id:14, task:'me9', start_at:'2025-01-11 05:00:00', end_at:'2025-01-11 08:00:00', message:null},
  //       {id:15, task:null, start_at:'2025-01-12 06:59:05', end_at:'2025-01-12 08:39:00', message:null},
  //       {id:16, task:'me9', start_at:'2025-01-14 03:45:07', end_at:null, message:null},
  //     ],
  //   }
  // }
}
