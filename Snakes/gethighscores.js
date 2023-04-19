const snakeget = "https://wmfvgv6cwe.execute-api.us-east-1.amazonaws.com/snake-get";

async function gethighscores() {
  try {
    const response = await fetch(snakeget);
    const data = await response.json();
    return data;
  } catch (error) {
    console.log(error);
    return null;
  }
}