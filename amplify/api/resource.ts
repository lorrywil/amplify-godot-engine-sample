import { Construct } from 'constructs';
import { Stack } from "aws-cdk-lib";
import {
  AuthorizationType,
  CognitoUserPoolsAuthorizer,
  Cors,
  LambdaIntegration,
  RestApi,
} from "aws-cdk-lib/aws-apigateway";
import { Policy, PolicyStatement, IRole } from "aws-cdk-lib/aws-iam";
import { IFunction } from 'aws-cdk-lib/aws-lambda';
import { UserPool,UserPoolResourceServer, UserPoolClient, OAuthScope } from 'aws-cdk-lib/aws-cognito';

//allows for the creation of api gateways backend.ts
export interface ApiGatewayProps {
  lambda: IFunction;
  authenticatedRole: IRole;
  unauthenticatedRole: IRole;
  userPoolId: string;
  authorizationType: 'COGNITO';
  authorizationScopes: ['openid','profile'];
}

export class ApiGatewayConstruct extends Construct {
  public readonly api: RestApi;
  
  constructor(scope: Construct, id: string, props: ApiGatewayProps) {
    super(scope, id);

    // Create REST API
    this.api = new RestApi(this, "AnalyticsRESTAPI", {
      restApiName: "AnalyticsRESTAPI",
      deploy: true,
      deployOptions: {
        stageName: "dev",
      },
      defaultCorsPreflightOptions: {
        allowOrigins: Cors.ALL_ORIGINS,
        allowMethods: Cors.ALL_METHODS,
        allowHeaders: Cors.DEFAULT_HEADERS,
      },
    });
    
    const cognitoAuthorizer = new CognitoUserPoolsAuthorizer(
      this,
      "CognitoAuthorizer",
      {
        cognitoUserPools: [
          UserPool.fromUserPoolId(this, "UserPool", props.userPoolId)
        ]
      }
    
    );
    // Integrats lambda function to API gateway
    const lambdaIntegration = new LambdaIntegration(props.lambda);

    // Create data path
    const itemsPath = this.api.root.addResource("data");
    //create cognito authoriser, to only allow users from amplify created user pool to use API gateway
    


    // Create API policy to allow invocation
    const AnalyticsAPIPolicy = new Policy(this, "AnalyticsAPIPolicy", {
      statements: [
        new PolicyStatement({
          actions: ["execute-api:Invoke"],
          resources: [
            `${this.api.arnForExecuteApi("*", "/data", "dev")}`,
            `${this.api.arnForExecuteApi("*", "/data/*", "dev")}`,
          ],
        }),
      ],
    });

    // Attach policies to roles
    props.authenticatedRole.attachInlinePolicy(AnalyticsAPIPolicy);
    props.unauthenticatedRole.attachInlinePolicy(AnalyticsAPIPolicy);
    //attach cognito authoriser to api gateway to only allow authenticated users to push data to AWS, also allows PUT requests to use lambda function
    itemsPath.addMethod("PUT", lambdaIntegration, {
      authorizer: cognitoAuthorizer,
      authorizationScopes: ['aws.cognito.signin.user.admin'],
      authorizationType: AuthorizationType.COGNITO
    });
  }
}
