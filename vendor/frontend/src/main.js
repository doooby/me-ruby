import { createApp } from 'vue'
import Page from '%root/components/Page.vue'
import Printout from '%root/components/global/Printout.vue'

const app = createApp(Page)

app.component('fe-printout', Printout);

app.mount('#me-fronted-app-root')
