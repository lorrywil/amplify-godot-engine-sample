import type { Handler } from 'aws-lambda';
import { BedrockRuntimeClient, InvokeModelCommand } from '@aws-sdk/client-bedrock-runtime';

export const handler: Handler = async (event, context) => {
  const { prompt, negativePrompt, colors, width, height, quality, cfgScale, seed, numberOfImages } = event.arguments
  const client = new BedrockRuntimeClient({ region: 'us-east-1' });
  const payload = {
    contentType: "application/json",
    accept: "application/json",
    modelId: "amazon.nova-canvas-v1:0",
    body: JSON.stringify({
      taskType: "COLOR_GUIDED_GENERATION",
      colorGuidedGenerationParams: {
        text: prompt,
        negativeText: negativePrompt,
        colors: colors.split(",")
      },
      imageGenerationConfig: {
        width: width || 1280,
        height: height || 720,
        quality: quality || "standard",
        cfgScale: cfgScale || 6.5,
        seed: seed || 0,
        numberOfImages: numberOfImages || 1
      }
    })
  };

  try {
    const command = new InvokeModelCommand(payload);
    const response = await client.send(command);
    const responseString =
      typeof response.body === "string"
        ? response.body
        : Buffer.from(response.body).toString("utf-8");
    const result = JSON.parse(responseString);
    return {
      statusCode: 200,
      body: result
    };
  } catch (error) {
    console.error("Error invoking Bedrock:", error);
    return {
      statusCode: 500,
      body: { "error": "There was an error" + error }
    };
  }

};