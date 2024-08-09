import { defineAuth } from '@aws-amplify/backend';

/**
 * Define and configure your auth resource
 * @see https://docs.amplify.aws/gen2/build-a-backend/auth
 */
export const auth = defineAuth({
  loginWith: {
    email: true,
  },
  userAttributes: {
    preferredUsername: {
      mutable: true,
      required: true
    },
    "custom:avatar_name": {
      dataType: "String",
      mutable: true,
      minLen: 4,
      maxLen: 25
    },
    "custom:avatar_color": {
      dataType: "String",
      mutable: true,
      minLen: 7,
      maxLen: 7
    }
  }
});
