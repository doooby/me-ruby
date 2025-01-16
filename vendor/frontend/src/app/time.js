import { parseISO, format as dateFnsFormat } from 'date-fns'
import * as app from '%root/src/app'

export function tryParse (value) {
  if (value instanceof Date) {
    return value
  } else if (typeof value === 'string') {
    return parseISO(value)
  }
}

export function format (value) {
  value = app.time.tryParse(value)
  if (value && !isNaN(value)) {
    return dateFnsFormat(value, 'd/m/Y HH:mm')
  }
}
