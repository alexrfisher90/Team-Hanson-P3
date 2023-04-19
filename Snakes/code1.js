
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

// ! Leaderboard
let first = document.querySelector('#first')
let second = document.querySelector('#second')
let third = document.querySelector('#third')
let fourth = document.querySelector('#fourth')
let fifth = document.querySelector('.fifth')

const fifthActive = document.querySelector('#fifthActive')

// ! tracks playername input
let playernameinput = document.querySelector('#playername')
let playername = undefined

// ! Name divs on leaderboard
let firstname = document.querySelector('#firstname')
let secondname = document.querySelector('#secondname')
let thirdname = document.querySelector('#thirdname')
let fourthname = document.querySelector('#fourthname')
let fifthname = document.querySelector('#fifthname')

// ! the name input bar
const inputname = document.querySelector('.playername')

// ! ok button to submit
const ok = document.querySelector('#ok')

updateScoreNames();


// ! shows the scores at he start
first.innerHTML = localStorage.getItem('first')
second.innerHTML = localStorage.getItem('second')
third.innerHTML = localStorage.getItem('third')
fourth.innerHTML = localStorage.getItem('fourth')
fifth.innerHTML = localStorage.getItem('fifth')

// ! Shows the names at the start, only if a name is present in local storage.
updateScoreNames()

function updateScoreNames() {
    if (localStorage.getItem('fifthname') !== undefined) {
        fifthname.innerHTML = localStorage.getItem('fifthname')
        if (localStorage.getItem('fourthname') !== undefined) {
            fourthname.innerHTML = localStorage.getItem('fourthname')
            if (localStorage.getItem('thirdname') !== undefined) {
                thirdname.innerHTML = localStorage.getItem('thirdname')
                if (localStorage.getItem('secondname') !== undefined) {
                    secondname.innerHTML = localStorage.getItem('secondname')
                    if (localStorage.getItem('firstname') !== undefined) {
                        firstname.innerHTML = localStorage.getItem('firstname')

                    }
                }
            }
        }
    }
}


// ! Show the scores at the start
first.innerHTML = localStorage.getItem('first')
second.innerHTML = localStorage.getItem('second')
third.innerHTML = localStorage.getItem('third')
fourth.innerHTML = localStorage.getItem('fourth')
fifth.innerHTML = localStorage.getItem('fifth')

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