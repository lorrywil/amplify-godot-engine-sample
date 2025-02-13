import { defineFunction } from '@aws-amplify/backend';

export const adsImageGenerator = defineFunction({
  // optionally specify a name for the Function (defaults to directory name)
  name: 'ads-image-generator',
  // optionally specify a path to your handler (defaults to "./handler.ts")
  entry: './handler.ts',
  timeoutSeconds: 60
});