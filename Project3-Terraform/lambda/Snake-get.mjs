// Create service client module using ES6 syntax.
import { DynamoDBClient, ScanCommand } from "@aws-sdk/client-dynamodb";
// Set the AWS Region.
const REGION = "us-east-1";
// Create an Amazon DynamoDB service client object.
const ddbClient = new DynamoDBClient({ region: REGION });
export { ddbClient };

// Set the parameters
export const handler = async(event,context) =>{ 
const params = {
  TableName: "snakehighscore",
  ProjectionExpression: "playername, highscore",
};

  try {
    const data = await ddbClient.send(new ScanCommand(params));
    const sortedItems = data.Items.sort((a, b) => {
      return b.highscore.N - a.highscore.N;
    });
    const top8Items = sortedItems.slice(0, 8);
    console.log("Success, top 8 items retrieved", top8Items);
    return top8Items;
  } catch (err) {
    console.log("Error", err);
  }
};