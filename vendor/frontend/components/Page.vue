<script setup>
  import UnknownPath from '%root/paths/UnknownPath.vue'
  import SummaryPath from '%root/paths/Summary.vue'

  const pathname = window.location.pathname
  console.log(`ME frontend, attaching to pathname ${pathname}`)

  let path
  switch (pathname) {
    case '/summary':
      path = SummaryPath
      break
  }
  const Component = path || UnknownPath
</script>

<template>
  <Component />
</template>
