const data = {
    tableName: "snakehighscore",
    Item: {
        playername: { S: "Testy" },
        highscore: { N: "1337" },
    },
};

const params = {
    method: "PUT",
    headers: {
        "Content-Type": "application/json",
    },
    body: JSON.stringify(data),
};

console.log("Request Body: ", params.body);

fetch("https://wmfvgv6cwe.execute-api.us-east-1.amazonaws.com/snake-push", params)
    .then((response) => response.json())
    .then((data) => console.log(data))
    .catch((error) => console.error(error));
