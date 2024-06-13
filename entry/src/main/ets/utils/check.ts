export function gobangCheck(x: number, y: number, result: number[][]) {
  //横（从这个点开始往前数5个，往后数5个，看看有没有5子相连的，记得判断边界情况，不能溢出）
  let startx = (x - 4) > 0 ? (x - 4) : 0;
  for (let i = startx; i <= x; i++) {
    if (i + 4 > 15) {
      break;
    }
    if (result[i][y] * result[i + 1][y] * result[i + 2][y] * result[i + 3][y] * result[i + 4][y] == 32) {
      return { res: 2, val: new Array(5).fill(0).map((v, index) => [i + index, y]) }
    }
    else if (result[i][y] * result[i + 1][y] * result[i + 2][y] * result[i + 3][y] * result[i + 4][y] == 1) {
      return { res: 1, val: new Array(5).fill(0).map((v, index) => [i + index, y]) }
    }
  }

  //纵（同横）
  let starty = y - 4;
  for (let i = starty; i <= y; i++) {
    if (i + 4 > 15) {
      break;
    }
    if (result[x][i] * result[x][i + 1] * result[x][i + 2] * result[x][i + 3] * result[x][i + 4] == 32) {
      return { res: 2, val: new Array(5).fill(0).map((v, index) => [x, i + index]) }
    }
    else if (result[x][i] * result[x][i + 1] * result[x][i + 2] * result[x][i + 3] * result[x][i + 4] == 1) {
      return { res: 1, val: new Array(5).fill(0).map((v, index) => [x, i + index]) }
    }
  }

  //正斜（x，y都在增加，判断边界情况，x大还是y大）
  if (x > y) {
    starty = y - 4 > 0 ? y - 4 : 0;
    startx = y - 4 > 0 ? (x - 4) : (x - (y - starty));
  } else {
    startx = x - 4 > 0 ? x - 4 : 0;
    starty = x - 4 > 0 ? (y - 4) : (y - (x - starty));
  }
  for (let i = startx; i <= x; i++) {
    if (i + 4 > 15 || starty + 4 > 15) {
      break;
    }
    if (result[i][starty] * result[i + 1][starty + 1] * result[i + 2][starty + 2] * result[i + 3][starty + 3] * result[i + 4][starty + 4] == 32) {
      return { res: 2, val: new Array(5).fill(0).map((v, index) => [i + index, starty + index]) }
    } else if (result[i][starty] * result[i + 1][starty + 1] * result[i + 2][starty + 2] * result[i + 3][starty + 3] * result[i + 4][starty + 4] == 1) {
      return { res: 1, val: new Array(5).fill(0).map((v, index) => [i + index, starty + index]) }
    }
    starty++;
  }

  //反斜（x在增加，y在减少，临界记得判断（0，15）-（15，0））
  startx = x - 4;
  starty = y + 4;
  if (startx < 0) {
    startx = 0;
    starty = y + (x - startx)
  }
  if (starty > 15) {
    starty = 15;
    startx = x - (15 - starty)
  }
  for (let i = startx; i <= x; i++) {
    if (i + 4 > 15 || starty - 4 < 0) {
      break
    }
    if (result[i][starty] * result[i + 1][starty - 1] * result[i + 2][starty - 2] * result[i + 3][starty - 3] * result[i + 4][starty - 4] == 32) {
      return { res: 2, val: new Array(5).fill(0).map((v, index) => [i + index, starty - index]) }
    } else if (result[i][starty] * result[i + 1][starty - 1] * result[i + 2][starty - 2] * result[i + 3][starty - 3] * result[i + 4][starty - 4] == 1) {
      return { res: 1, val: new Array(5).fill(0).map((v, index) => [i + index, starty - index]) }
    }
    starty--;
  }
}
