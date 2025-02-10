import { defineBackend } from '@aws-amplify/backend';
import * as iam from "aws-cdk-lib/aws-iam"
import { auth } from './auth/resource';
import { data } from './data/resource';
import { storage } from './storage/resource';
import { adsImageGenerator } from './functions/ads-image-generator/resource'

/**
 * @see https://docs.amplify.aws/react/build-a-backend/ to add storage, functions, and more
 */
const backend = defineBackend({
    auth,
    data,
    storage,
    adsImageGenerator
});
backend.auth.resources.cfnResources.cfnUserPoolClient.explicitAuthFlows = [
    "ALLOW_CUSTOM_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_USER_PASSWORD_AUTH"
]

const adsImageGeneratorLambda = backend.adsImageGenerator.resources.lambda

const statement = new iam.PolicyStatement({
    sid: "AllowInvokeBedrockModelAndGetDynamoDBItem",
    actions: ["bedrock:InvokeModel"],
    resources: [
      "arn:aws:bedrock:us-east-1::foundation-model/*",
    ],
  })
  
  adsImageGeneratorLambda.addToRolePolicy(statement)