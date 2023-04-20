// LOADER ON START

$(window).on('load', function () {
  $('.loader-wrapper').slideUp()
})
window.onload = function () {
  gethighscores().then(highscores => {
    console.log("Highscores: ", highscores);
    displayhighscores(highscores);
  }).catch(error => {
    console.log("Error: ", error);
  }); 'load', function () {
    $('.loader-wrapper').slideUp()
  }
}


//! Settings
const settings = document.querySelector('.settings')
const keys = document.querySelector('#keys')
const normal = document.querySelector('.normal')
const fast = document.querySelector('.fast')
const rapid = document.querySelector('.rapid')
const godlike = document.querySelector('.godlike')

// ! Space bar div
const instr = document.querySelector('.instr')

// ! Audio & ambience
const ambience = document.querySelector('.amb')
const audioPlayer = document.querySelector('audio')

// ! Snake animation
const snakegraphic = document.querySelector('.graphic')

const gelatine = document.querySelector('.graphicgelatine')


// ! screen points update
const navtext1 = document.querySelector('#navtext1')
const navtext2 = document.querySelector('#navtext2')
const navtext3 = document.querySelector('#navtext3')


const fifthActive = document.querySelector('#fifthActive')

// ! tracks playername input
let playernameinput = document.querySelector('#playername')
let playername = undefined


// ! the name input bar
const inputname = document.querySelector('.playername')

// ! ok button to submit
const ok = document.querySelector('#ok')

//THIS CODE IS STUPID

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

const leaderboard = document.querySelector('#leaderboard');

async function updateScoreNames() {
  console.log("Updating score names...");

  const highscores = await gethighscores();
  console.log("Highscores:", highscores);

  const scores = [];
  const names = [];
  const snakeget = "https://wmfvgv6cwe.execute-api.us-east-1.amazonaws.com/snake-get";

  if (highscores) {
    console.log("Items found. Looping through...");
    highscores.forEach((obj) => {
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

function displayhighscores(highscores) {
  const leaderboard = document.querySelector("#leaderboard");

  if (highscores) {
    console.log("Items found. Looping through...");
    const items = highscores;
    const numItems = highscores.length > 10 ? 10 : highscores.length;

    for (let i = 0; i < highscores.length; i++) {
      const obj = highscores[i];
      if (obj.highscore && obj.highscore.N && obj.playername && obj.playername.S) {
        const score = Number(obj.highscore.N);
        const name = obj.playername.S;
        const listItem = document.querySelector(`#name${i + 1}`);
        if (listItem) {
          listItem.textContent = `${name}: ${score}`;
        }
      }
    }
  } else {
    console.log("No items found.");
  }
}


// ! OK button listener
ok.addEventListener('click', () => {
  audioPlayer.src = './aud/click.mp3'
  audioPlayer.play()
  playername = playernameinput.value
  playername = playername.charAt(0).toUpperCase() + playername.slice(1)
  inputname.style.visibility = 'hidden'
  fifth.classList.add('fifthActive')
})


// ! Game variables
const game = document.querySelector('.game')
const width = 20

// ! Score variables
let score = document.querySelector('#score')
let scoreTotal = 0

// ! Variable points for given speed selected
let activepoints = [1, 3, 10]

// ! Spped of the game (interval)
let speed = 100

// ! The snake
let snake = [210, 230, 250]

// ! The field of cells
const cells = []

// ! Creating the game field, generating cells
for (let i = 0; i < width ** 2; i++) {
  const div = document.createElement('div')
  div.classList.add('cell')
  game.appendChild(div)
  cells.push(div)
}

// ! Assign the snake to the field
snake.forEach((body) => {
  cells[body].classList.add('snake')
})

// ! Creating a new frame each time the snake moves
function newFrame() {

  for (var i = 0; i < cells.length; i++) {
    cells[i].classList.remove('snake')
  }

  snake.forEach((body) => {
    cells[body].classList.add('snake')

  })

}

// ! Snake active direction
let direction = 'up'


// ! Function to check for spacebar input, and start the game
function toggleStartEvent(event) {

  if (event.key === ' ') {

    ambience.play()
    audioPlayer.src = './aud/start.mp3'
    audioPlayer.play()
    snake = [210, 230, 250]
    scoreTotal = 0
    score.innerHTML = scoreTotal
    direction = 'up'

    instr.style.visibility = 'hidden'
    settings.style.visibility = 'hidden'
    keys.style.visibility = 'hidden'
    inputname.style.visibility = 'hidden'
    fifth.classList.add('fifthActive')

    for (var i = 0; i < cells.length; i++) {
      cells[i].classList.remove('gameover')
    }

    startGame()
  }
}

// ! Add an event listener to window, needed to start the game
window.addEventListener('keypress', toggleStartEvent)

// ! Starting the game
function startGame() {

  window.removeEventListener('keypress', toggleStartEvent)
  cells[randomFood].classList.add('food')
  const interval = setInterval(() => {


    if (direction === 'right' && (snake[0] % width !== width - 1)) {
      snake.unshift(snake[0] + 1)
      snake.pop()
      newFrame()

    } else if (direction === 'right' && (snake[0] % width === width - 1)) {
      snake.unshift(snake[0] - 19)
      snake.pop()
      newFrame()

    } else if (direction === 'up' && snake[0] >= width) {
      snake.unshift(snake[0] - width)
      snake.pop()
      newFrame()

    } else if (direction === 'up' && snake[0] < width) {
      snake.unshift(snake[0] + 380)
      snake.pop()
      newFrame()

    } else if (direction === 'down' && snake[0] < 380) {
      snake.unshift(snake[0] + width)
      snake.pop()
      newFrame()

    } else if (direction === 'down' && snake[0] > 379) {
      snake.unshift(snake[0] - 380)
      snake.pop()
      newFrame()

    } else if (direction === 'left' && snake[0] % width !== 0) {
      snake.unshift(snake[0] - 1)
      snake.pop()
      newFrame()

    } else if (direction === 'left' && snake[0] % width === 0) {
      snake.unshift(snake[0] + 19)
      snake.pop()
      newFrame()

    }

    contact()

    // ! Checks snake for contact with itself
    function contact() {
      for (i = 0; i < snake.length; i++) {
        if (snake.indexOf(snake[i]) !== snake.lastIndexOf(snake[i])) {

          clearInterval(interval)

          for (var i = 0; i < cells.length; i++) {
            cells[i].classList.remove('snake', 'food', 'rare', 'crate')
          }

          gameover.forEach((over) => {
            cells[over].classList.add('gameover')
          })

          checkLeaderboard()
          instr.style.visibility = 'visible'
          window.addEventListener('keypress', toggleStartEvent)
          settings.style.visibility = 'visible'
          keys.style.visibility = 'visible'
          inputname.style.visibility = 'visible'
          fifth.classList.remove('fifthActive')

          audioPlayer.src = './aud/3.mp3'
          audioPlayer.play()

          ambience.pause()
          start.style.visibility = 'visible'

        }
      }
    }

    //! The food logic
    if (snake[0] === randomFood) {

      cells[randomFood].classList.remove('food')
      // add points
      scoreTotal += activepoints[0]
      score.innerHTML = scoreTotal

      // play sound
      audioPlayer.src = './aud/1.mp3'
      audioPlayer.play()

      // make snake bigger
      snake.push(snake[0])

      // run code to generate more
      generateFood()

    } if (snake[0] === randomRareFood) {

      cells[randomRareFood].classList.remove('rare')

      randomRareFood = undefined
      generateRareFood()
      // add points
      scoreTotal += activepoints[1]
      score.innerHTML = scoreTotal

      audioPlayer.src = './aud/2.mp3'
      audioPlayer.play()

      // make snake bigger

      snake.push(snake[0])

      snakegraphic.classList.add('graphicgelatine')

      setTimeout(() => {

        snakegraphic.classList.remove('graphicgelatine')
      }, 2000)

    }

    // ! Crate contact logic

    if (snake[0] === randomCrate) {

      cells[randomCrate].classList.remove('crate')

      randomCrate = undefined
      generateCrate()
      // add points
      scoreTotal += activepoints[2]
      score.innerHTML = scoreTotal
      // play sounds
      audioPlayer.src = './aud/crate.mp3'
      audioPlayer.play()

      // make snake bigger

      snake.push(snake[0])

      snakegraphic.classList.add('graphicgelatine')

      setTimeout(() => {

        snakegraphic.classList.remove('graphicgelatine')
      }, 2000)

    }

  }, speed)

}

// ! Adding the food at the start of the game
let randomFood = Math.floor(Math.random() * (width ** 2))
cells[randomFood].classList.add('food')

// ! Food generator if snakes eats the food on the field, wont generate in the snake.
function generateFood() {

  randomFood = Math.floor(Math.random() * (width ** 2))

  if (snake.includes(randomFood)) {
    generateFood()
  } else {
    cells[randomFood].classList.add('food')
  }
}


// ! Rare food generator starts when snake eats the first rare food.
let randomRareFood = Math.floor(Math.random() * (width ** 2))

setTimeout(() => {

  cells[randomRareFood].classList.add('rare')

}, 5000)


function generateRareFood() {

  setTimeout(() => {

    randomRareFood = Math.floor(Math.random() * (width ** 2))
    cells[randomRareFood].classList.add('rare')

    setTimeout(() => {

      if (randomRareFood > 0) {
        cells[randomRareFood].classList.remove('rare')
        randomRareFood = undefined
        generateRareFood()
        if (randomRareFood === undefined) {
          return

        }
      }
    }, 3000)

  }, 10000)

}

// ! Crate generator when snake eats the first crate.

let randomCrate = Math.floor(Math.random() * (width ** 2))

setTimeout(() => {

  cells[randomCrate].classList.add('crate')


}, 10000)


function generateCrate() {

  setTimeout(() => {

    randomCrate = Math.floor(Math.random() * (width ** 2))
    cells[randomCrate].classList.add('crate')

    setTimeout(() => {

      if (randomCrate > 0) {
        cells[randomCrate].classList.remove('crate')
        randomCrate = undefined
        generateCrate()
        if (randomCrate === undefined) {
          return

        }
      }
    }, 3000)


  }, 20000)

}

// ! Listeners on the arrows, changes the direction of the snake
window.addEventListener('keydown', (event) => {
  const key = event.key
  console.log(key)
  if (key === 'ArrowUp') {
    direction = 'up'
  } else if (key === 'ArrowDown') {
    direction = 'down'
  } else if (key === 'ArrowLeft') {
    direction = 'left'
  } else if (key === 'ArrowRight') {
    direction = 'right'
  }

})


// ! Snake buttons for mobile
const up = document.querySelector('#up')
const down = document.querySelector('#down')
const left = document.querySelector('#left')
const right = document.querySelector('#right')
const start = document.querySelector('#start')

// ! Listeners for mobile
up.addEventListener('mousedown', () => {
  direction = 'up'
})
down.addEventListener('mousedown', () => {
  direction = 'down'
})
left.addEventListener('mousedown', () => {
  direction = 'left'
})
right.addEventListener('mousedown', () => {
  direction = 'right'
})
start.addEventListener('click', () => {
  ambience.play()
  audioPlayer.src = './aud/start.mp3'
  audioPlayer.play()
  snake = [210, 230, 250]
  scoreTotal = 0
  score.innerHTML = scoreTotal
  direction = 'up'

  instr.style.visibility = 'hidden'
  settings.style.visibility = 'hidden'
  keys.style.visibility = 'hidden'
  inputname.style.visibility = 'hidden'
  fifth.classList.add('fifthActive')

  for (var i = 0; i < cells.length; i++) {
    cells[i].classList.remove('gameover')
  }
  start.style.visibility = 'hidden'
  startGame()
})

// ! Listeners on the speed settings 
normal.classList.add('activeSpeed')

normal.addEventListener('click', () => {
  audioPlayer.src = './aud/click.mp3'
  audioPlayer.play()
  speed = 100
  activepoints = [1, 3, 10]
  navtext1.innerHTML = '1 point'
  navtext2.innerHTML = '3 points'
  navtext3.innerHTML = '10 points'
  normal.classList.add('activeSpeed')
  fast.classList.remove('activeSpeed')
  rapid.classList.remove('activeSpeed')
  godlike.classList.remove('activeSpeed')
})

fast.addEventListener('click', () => {
  audioPlayer.src = './aud/click.mp3'
  audioPlayer.play()
  speed = 70
  activepoints = [2, 4, 11]
  navtext1.innerHTML = '2 points'
  navtext2.innerHTML = '4 points'
  navtext3.innerHTML = '11 points'
  fast.classList.add('activeSpeed')
  normal.classList.remove('activeSpeed')
  rapid.classList.remove('activeSpeed')
  godlike.classList.remove('activeSpeed')
})

rapid.addEventListener('click', () => {
  audioPlayer.src = './aud/click.mp3'
  audioPlayer.play()
  speed = 50
  activepoints = [3, 5, 12]
  navtext1.innerHTML = '3 points'
  navtext2.innerHTML = '5 points'
  navtext3.innerHTML = '12 points'
  rapid.classList.add('activeSpeed')
  normal.classList.remove('activeSpeed')
  fast.classList.remove('activeSpeed')
  godlike.classList.remove('activeSpeed')
})

godlike.addEventListener('click', () => {
  audioPlayer.src = './aud/click.mp3'
  audioPlayer.play()
  speed = 30
  activepoints = [4, 6, 13]
  navtext1.innerHTML = '4 points'
  navtext2.innerHTML = '6 points'
  navtext3.innerHTML = '13 points'
  godlike.classList.add('activeSpeed')
  normal.classList.remove('activeSpeed')
  fast.classList.remove('activeSpeed')
  rapid.classList.remove('activeSpeed')
})


// ! Logic of the leaderboard
function checkLeaderboard() {
  let checkHighScore = scoreTotal

  if (checkHighScore < localStorage.getItem('fourth') && checkHighScore > localStorage.getItem('fifth')) {

    localStorage.setItem('fifth', scoreTotal)
    fifth.innerHTML = scoreTotal

    if (playername !== undefined) {
      localStorage.setItem('fifthname', playername)
      fifthname.innerHTML = playername
      updateScoreNames()
    } else if (playername === undefined) {
      localStorage.setItem('fifthname', '')

      updateScoreNames()
    }


  } else if (checkHighScore < localStorage.getItem('first')
    && checkHighScore < localStorage.getItem('second')
    && checkHighScore < localStorage.getItem('third')
    && checkHighScore > localStorage.getItem('fifth')) {

    localStorage.setItem('fourth', scoreTotal)
    fourth.innerHTML = scoreTotal

    if (playername !== undefined) {
      localStorage.setItem('fourthname', playername)
      fourthname.innerHTML = playername
      updateScoreNames()
    } else if (playername === undefined) {
      localStorage.setItem('fourthname', '')

      updateScoreNames()
    }


  } else if (checkHighScore < localStorage.getItem('first')
    && checkHighScore < localStorage.getItem('second')
    && checkHighScore > localStorage.getItem('fourth')
    && checkHighScore > localStorage.getItem('fifth')) {

    localStorage.setItem('third', scoreTotal)
    third.innerHTML = scoreTotal

    if (playername !== undefined) {
      localStorage.setItem('thirdname', playername)
      thirdname.innerHTML = playername
      updateScoreNames()
    } else if (playername === undefined) {
      localStorage.setItem('thirdname', '')

      updateScoreNames()
    }

  } else if (checkHighScore < localStorage.getItem('first')
    && checkHighScore > localStorage.getItem('third')
    && checkHighScore > localStorage.getItem('fourth')
    && checkHighScore > localStorage.getItem('fifth')) {

    localStorage.setItem('second', scoreTotal)
    second.innerHTML = scoreTotal

    if (playername !== undefined) {
      localStorage.setItem('secondname', playername)
      secondname.innerHTML = playername
      updateScoreNames()
    } else if (playername === undefined) {
      localStorage.setItem('secondname', '')

      updateScoreNames()
    }

  } else if (checkHighScore > localStorage.getItem('second')
    && checkHighScore > localStorage.getItem('third')
    && checkHighScore > localStorage.getItem('fourth')
    && checkHighScore > localStorage.getItem('fifth')) {

    localStorage.setItem('first', scoreTotal)
    first.innerHTML = scoreTotal

    if (playername !== undefined) {
      localStorage.setItem('firstname', playername)
      firstname.innerHTML = playername
      updateScoreNames()
    } else if (playername === undefined) {
      localStorage.setItem('firstname', '')

      updateScoreNames()
    }

  }

}


console.log(window.localStorage)

// ! Gameover splash screen
const gameover = [101, 102, 103, 104, 121, 141, 161, 181, 182,
  183, 184, 164, 144, 143, 186, 166, 146, 126, 107, 108, 129,
  149, 169, 189, 147, 148, 191, 171, 151, 131, 133, 111, 132,
  114, 134, 154, 174, 194, 196, 176, 156, 136, 116, 117, 118,
  157, 158, 197, 198, 221, 241, 261, 281, 301, 222, 223, 224,
  244, 264, 284, 304, 303, 302, 226, 246, 229, 249, 269, 266,
  287, 288, 231, 251, 271, 291, 311, 232, 233, 272, 273, 307,
  308, 312, 313, 236, 237, 238, 237, 238, 277, 278, 318, 235,
  255, 275, 295, 315, 258, 276, 297]