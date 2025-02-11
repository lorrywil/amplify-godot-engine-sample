import {APIGatewayProxyEventV2, APIGatewayProxyResultV2,APIGatewayProxyHandler} from 'aws-lambda';
import { Firehose } from 'aws-sdk';
//lambda function that recieves json events from game client and pushes it to data firehose stream, takes environment variable of the stream name from resource.ts
export const handler: APIGatewayProxyHandler = async (event)=> {
  const firehose = new Firehose();
  try{
    const body = event.body ? JSON.parse(event.body) : null;
    if(!body){
      return {
        statusCode: 400,
        body: JSON.stringify({
          message: 'No body found',
        }),
      };
    }
    const record = {
      DeliveryStreamName: process.env.FIREHOSE_STREAM_NAME!, 
      Record: {
        Data: JSON.stringify(body) + '\n'
      }
    };

    await firehose.putRecord(record).promise();

    return {
      statusCode: 200,
      body: JSON.stringify({
        message: 'Data successfully sent to Firehose',
        data: body
      }),
    };

  }
  
  catch (error) {
    return {
      statusCode: 500,
      body: JSON.stringify({
        message: 'Error processing request',
        error: error instanceof Error ? error.message : 'Unknown error',
      }),
    };
  }
  return {
    statusCode: 200,
    body: JSON.stringify({
      message: event.body
    }),
  };
};

