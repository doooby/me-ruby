export * as tasks from './tasks/index.js'
export * as time from './time.js'
export { default as DataReader } from './DataReader.js'

const env = {
  serverUrl :import.meta.env.ME_SERVER_URL,
}
export { env }
