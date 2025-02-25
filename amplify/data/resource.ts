import { type ClientSchema, a, defineData } from "@aws-amplify/backend";
import { adsImageGenerator } from "../functions/ads-image-generator/resource";

const schema = a.schema({
  Score: a.model({
    leaderboard: a.string().required(),
    username: a.string().required(),
    score: a.integer().required(),
  }).identifier(["leaderboard", "username"])
    .secondaryIndexes(index => [index("leaderboard").sortKeys(["score"])])
    .authorization(allow => [allow.publicApiKey()]),
  adsImageGenerator: a
    .query()
    .arguments({
      prompt: a.string().required(),
      negativePrompt: a.string(),
      colors: a.string(),
      width: a.integer(),
      height: a.integer(),
      cfgScale: a.float(),
      seed: a.integer(),
      numberOfImages: a.integer()
    })
    .returns(a.json())
    .handler(a.handler.function(adsImageGenerator))
    .authorization(allow => [allow.publicApiKey()]),
});

export type Schema = ClientSchema<typeof schema>;

export const data = defineData({
  schema,
  authorizationModes: {
    defaultAuthorizationMode: 'apiKey',
    apiKeyAuthorizationMode: {
      expiresInDays: 30,
    },
  },
});