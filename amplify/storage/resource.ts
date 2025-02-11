import { defineStorage } from "@aws-amplify/backend";

export const storage = defineStorage({
  name: 'builds'
})


export const analyticsstorage =  defineStorage({
  name: 'analytics',
  isDefault: true
})

export const gluestorage =  defineStorage({
  name: 'gluebucket'
})