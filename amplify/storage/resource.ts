import { defineStorage } from "@aws-amplify/backend";

export const storage = defineStorage({
  name: 'default'
});

export const analyticsstorage =  defineStorage({
  name: 'analytics',
  isDefault: true
})

export const gluestorage =  defineStorage({
  name: 'gluebucket'
})
