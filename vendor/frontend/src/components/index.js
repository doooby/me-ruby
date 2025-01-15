import * as app from '%root/src/app'
import toolkit from './toolkit'
import { format as dateFnsFormat } from 'date-fns'

const components = {
  toolkit,

  format: {
    time (value) {
      value = app.time.tryParse(value)
      if (value && !isNaN(value)) {
        return dateFnsFormat(value, 'd/m/Y HH:mm')
      }
    }
  },
}

export default components
