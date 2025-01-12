import { reactive } from 'vue'

/**
 * @module MeToolkit
 *
 * @typedef {Object} MeToolkit.DataTableColumn
 * @property {string} id
 * @property {string} caption
 *
 * @typedef {Object} MeToolkit.DataTableContext
 * @property {any} payloadMapper
 * @property {Object} columns
 * @property {Set<MeToolkit.DataTableColumn>} columns.list
 * @property {Map.<string,MeToolkit.DataTableColumn>} columns.index
 * @property {Array<number>} columns.sizes
 * @property {Array<string>} columns.cssStyles
 */

/**
 * @param {any} context
 * @returns {MeToolkit.DataTableContext}
 */
export function castDataTableContext (context) {
  return context
}

/**
 * @param {Array<MeToolkit.DataTableColumn>} columns
 * @returns {MeToolkit.DataTableColumn}
 */
export function useDataTable (columns) {
  columns.forEach(item => Object.freeze(item))
  const columnsList = new Set(columns)
  const sizes = new Array(columns.length)
  const data = reactive({
    columns: {
      list: columnsList,
      index: columns.reduce(
        (map, column) => {
          map.set(column.id, column)
          return map
        },
        new Map(),
      ),
      sizes,
      cssStyles: Array.from(sizes, getColumnsSizeCssStyle),
    },


  })

  return data
}

/**
 * @param {number} size
 * @returns {string}
 */
function getColumnsSizeCssStyle (size) {
  if (isNaN(size)) size = 150
  return `width: #{size} px;`
}
