import { createApp } from 'vue'
import Router from '%root/components/Router.vue'
import BoxWithCaption from '%root/components/global/BoxWithCaption.vue'
import InputSearch from '%root/components/global/InputSearch.vue'

const app = createApp(Router)

app.component('input-search', InputSearch);
app.component('box-with-caption', BoxWithCaption);

app.mount('#me-fronted-app-root')
