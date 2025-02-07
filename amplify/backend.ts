import { defineBackend } from '@aws-amplify/backend';
import { auth } from './auth/resource';
import { gluestorage, analyticsstorage } from './storage/resource'
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
  myApiFunction,
  analyticsstorage,
  gluestorage
});




const analyticsStack = backend.createStack('analytics');

const analyticsStream = new FirehoseToS3(analyticsStack, "AnalyticsStream", {
  streamName: "analytics-stream",
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
const crawler = new gluecrawler(analyticsStack, "Crawler", {
  bucket: backend.analyticsstorage.resources.bucket,
  databaseName: "gameanalytics",
  tableName: "squashgodot"
});

const apiStack = backend.createStack("api-stack");
const { cfnUserPoolClient } = backend.auth.resources.cfnResources;
cfnUserPoolClient.explicitAuthFlows = [ 'ALLOW_USER_PASSWORD_AUTH', 'ALLOW_REFRESH_TOKEN_AUTH', 'ALLOW_USER_SRP_AUTH']
cfnUserPoolClient.allowedOAuthScopes = ['openid','profile'];
cfnUserPoolClient.generateSecret = false;
const { userPool } = backend.auth.resources;

const apiGateway = new ApiGatewayConstruct(apiStack, "AnalyticsApiGateway", {
  lambda: backend.myApiFunction.resources.lambda,
  authenticatedRole: backend.auth.resources.authenticatedUserIamRole,
  unauthenticatedRole: backend.auth.resources.unauthenticatedUserIamRole,
  userPoolId: backend.auth.resources.userPool.userPoolId,
  authorizationType: 'COGNITO',
  authorizationScopes: ['openid','profile'],
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
      },
    },
  },
});

