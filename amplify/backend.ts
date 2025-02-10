import { defineBackend } from '@aws-amplify/backend';
import { auth } from './auth/resource';
import { data } from './data/resource';
import { storage,gluestorage,analyticsstorage } from './storage/resource'
import { Stack } from "aws-cdk-lib";
import { PolicyStatement } from "aws-cdk-lib/aws-iam";
import { myApiFunction } from "./functions/myApi/resource";
import { FirehoseToS3 } from './analytics/resource';
import { gluecrawler } from './etl/resources';
import { Duration } from 'aws-cdk-lib';
import { ApiGatewayConstruct } from './api/resource';
/**
 * @see https://docs.amplify.aws/react/build-a-backend/ to add storage, functions, and more
 */
export const backend = defineBackend({
    auth,
    data,
    storage,
    myApiFunction,
    analyticsstorage,
    gluestorage
});
backend.auth.resources.cfnResources.cfnUserPoolClient.explicitAuthFlows = [
    "ALLOW_CUSTOM_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_USER_PASSWORD_AUTH"
]

const analyticsStack = backend.createStack('Gameanalytics');

const analyticsStream = new FirehoseToS3(analyticsStack, "GameAnalyticsStream", {
  streamName: "analytics-firehosestream",
  bucket: backend.analyticsstorage.resources.bucket,
  bufferInterval: Duration.seconds(60),
  bufferSize: 1,
  prefix: "data/!{timestamp:yyyy}/!{timestamp:MM}/!{timestamp:dd}/",
  errorPrefix: "errors/data/!{firehose:error-output-type}/!{timestamp:yyyy}/!{timestamp:MM}/!{timestamp:dd}/",
});
const lambdastatement = new PolicyStatement({
  actions: ['firehose:PutRecord', 'firehose:PutRecordBatch'],
  resources: ['arn:aws:firehose:*:*:deliverystream/' + analyticsStream.deliveryStream.deliveryStreamName]
});

const firehoselambda = backend.myApiFunction.resources.lambda;
firehoselambda.addToRolePolicy(lambdastatement);
// Export the resources if needed
const crawler = new gluecrawler(analyticsStack, "GlueCrawler", {
  bucket: backend.analyticsstorage.resources.bucket,
  databaseName: "gdcgameanalytics",
  tableName: "squashgodot"
});

const apiStack = backend.createStack("analytics-api-stack");
const { cfnUserPoolClient } = backend.auth.resources.cfnResources;
cfnUserPoolClient.explicitAuthFlows = [ 'ALLOW_USER_PASSWORD_AUTH', 'ALLOW_REFRESH_TOKEN_AUTH', 'ALLOW_USER_SRP_AUTH']
cfnUserPoolClient.allowedOAuthScopes = ['openid','profile'];
cfnUserPoolClient.generateSecret = false;
const { userPool } = backend.auth.resources;

const apiGateway = new ApiGatewayConstruct(apiStack, "AnalyticsApi", {
  lambda: backend.myApiFunction.resources.lambda,
  authenticatedRole: backend.auth.resources.authenticatedUserIamRole,
  unauthenticatedRole: backend.auth.resources.unauthenticatedUserIamRole,
  userPoolId: backend.auth.resources.userPool.userPoolId,
  authorizationType: 'API_KEY',
  apiKeyRequired: true
});



// Create analytics resources after backend is defined
// add outputs to the configuration file
backend.addOutput({
  custom: {
    API: {
      [apiGateway.api.restApiName]: {
        endpoint: apiGateway.api.url,
        region: Stack.of(apiGateway.api).region,
        apiName: apiGateway.api.restApiName,
        apiKeyID: apiGateway.apiKey.keyId,
        apiKeyValue: "run [aws apigateway get-api-key --api-key <api-key-id> --include-value --query \"value\" --output text] and paste here"
      },
    },
  },
});