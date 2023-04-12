import { gethighscores } from './gethighscores.mjs';

gethighscores().then((data) => console.log(data)).catch((error) => console.error(error));
