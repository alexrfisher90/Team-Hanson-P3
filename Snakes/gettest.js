const snakeget = "https://el6v7i77d4.execute-api.us-east-1.amazonaws.com/prod/";

const gethighscores = async () => {
  try {
    const response = await fetch(snakeget, {
      method: "GET"
    });
    const data = await response.json();
    return data;
  } catch (error) {
    console.log(error);
    return null;
  }
};


gethighscores().then((data) => console.log(data)).catch((error) => console.error(error));