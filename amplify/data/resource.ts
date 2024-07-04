import { type ClientSchema, a, defineData } from '@aws-amplify/backend';

const schema = a.schema({
  Leaderboard: a.model({
    userId: a.string().required(),
    username: a.string().required(),
    score: a.integer().required(),
    rank: a.integer(),
    lastUpdated: a.datetime()
  })
});

export type Schema = ClientSchema<typeof schema>;

export const data = defineData({
  schema,
  authorizationModes: {
    defaultAuthorizationMode: "userPool"
  }
});
