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
      // Add any arguments your imageGenerator function needs
      prompt: a.string(),
      negativePrompt: a.string(), //  Example argument
    })
    .returns(a.string()) // Adjust the return type based on what your function returns
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