import promptAction from '@ohos.promptAction';
export async function gameOver(val: number) {
  try {
    return promptAction.showDialog({
      title: '游戏结束',
      message:  `${val === 1 ? '黑棋' : '白棋'}获胜`,
      buttons: [
        {
          text: '关 闭',
          color: '#FF007DFF',
        },
        {
          text: '再来一盘',
          color: '#FF007DFF',
        }
      ],
    })
  } catch (err) {
    console.error(`showActionMenu args error code is ${err.code}, message is ${err.message}`);
    return { index: 0}
  }
}

export async function whoFirst() {
  try {
    return promptAction.showDialog({
      title: '选择先手',
      message:  `谁是先手下子`,
      buttons: [
        {
          text: '电脑',
          color: '#0bb20c',
        },
        {
          text: '我',
          color: '#0bb20c',
        }
      ],
    })
  } catch (err) {
    console.error(`showActionMenu args error code is ${err.code}, message is ${err.message}`);
    return { index: 0}
  }
}