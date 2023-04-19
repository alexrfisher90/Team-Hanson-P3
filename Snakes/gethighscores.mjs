export const snakeget = "https://wmfvgv6cwe.execute-api.us-east-1.amazonaws.com/snake-get";

export async function gethighscores() {
  try {
    const response = await fetch(snakeget);
    const data = await response.json();

    // Map each object in the data array to a new object with properties playername and highscore
    const highscores = data.map(item => ({
      playername: item.playername.S,
      highscore: parseInt(item.highscore.N)
    }));

    return highscores;
  } catch (error) {
    console.log(error);
    return null;
  }
}