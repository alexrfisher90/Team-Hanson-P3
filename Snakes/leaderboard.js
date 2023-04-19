window.onload = function () {
  gethighscores().then(highscores => {
    console.log("Highscores: ", highscores);
    displayhighscores(highscores);
  }).catch(error => {
    console.log("Error: ", error);
  });
}

const leaderboard = document.querySelector('#leaderboard');

async function updateScoreNames() {
  console.log("Updating score names...");

  const highscores = await gethighscores();
  console.log("Highscores:", highscores);

  const scores = [];
  const names = [];
  const snakeget = "https://wmfvgv6cwe.execute-api.us-east-1.amazonaws.com/snake-get";

  if (highscores && highscores.Items) {
    console.log("Items found. Looping through...");
    highscores.Items.forEach((obj) => {
      if (obj.highscore && obj.highscore.N && obj.playername && obj.playername.S) {
        scores.push(Number(obj.highscore.N));
        names.push(obj.playername.S);
      }
    });

    leaderboard.innerHTML = '';
    for (let i = 0; i < scores.length; i++) {
      const listItem = document.createElement('li');
      listItem.textContent = `${i + 1}. ${names[i]} - ${scores[i]}`;
      leaderboard.appendChild(listItem);
    }
  } else {
    console.log("No items found.");
  }
}

async function gethighscores() {
  try {
    const response = await fetch("https://wmfvgv6cwe.execute-api.us-east-1.amazonaws.com/snake-get");
    const data = await response.json();
    return data;
  } catch (error) {
    console.log(error);
    return null;
  }
}

function displayhighscores(highscores) {
  const leaderboard = document.querySelector("#leaderboard");
  leaderboard.innerHTML = "";

  if (highscores) {
    console.log("Items found. Looping through...");
    highscores.forEach((obj) => {
      if (obj.highscore && obj.highscore.N && obj.playername && obj.playername.S) {
        const score = Number(obj.highscore.N);
        const name = obj.playername.S;
        const listItem = document.createElement("li");
        listItem.textContent = `${name}: ${score}`;
        leaderboard.appendChild(listItem);
      }
    });
  } else {
    console.log("No items found.");
  }
}



updateScoreNames();
