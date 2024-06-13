import { gobangCheck } from '../../utils/check'
import { UseController } from '../../utils/controller'
import {
ONE_STEP_EVENT_KEY,
  PLAYER_CHANGE_EVENT_KEY,
  RESTART_EVENT_KEY,
  RESULT_CHANGE_EVENT_KEY,
  UNDO_EVENT_KEY,
  WIN_EVENT_KEY
} from './const'
import { GobangChess } from './gobangChess'
import { Chess, drawGobang, drawRoundedRect, getChess, getResultVal } from './lib'
import { PlayChessMedia } from './media'
export const controller: UseController = new UseController()
@Component
export struct Gobang {
  @Prop disabled: boolean
  @State history: Array<Chess> = []
  @State lastChess: Chess = null
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private gap: number = 40
  private player = 1
  private result = getResultVal()
  private chessMedia: PlayChessMedia
  aboutToAppear() {
    this.chessMedia = new PlayChessMedia(getContext(this))
    controller.on(UNDO_EVENT_KEY, (step) => this.undoMove(step || 1))
    controller.on(RESTART_EVENT_KEY, () => this.restart())
    controller.on(ONE_STEP_EVENT_KEY,(x, y)=> this.oneStep(x, y))
  }
  handleWin(res: number[][], play) {
    const winChess = res.map(v => v.join('-'))
    this.history.forEach((item, index) => {
      this.history[index].context = index + 1 + ''
      const f = winChess.findIndex(v => v === item.key)
      if (f > -1) {
        item.winIndex = f + 1
        this.history[index].shadow = { radius: 2, offsetY: 0, offsetX: 0, color: 0xffd507 }
      }
    })
    controller.emit(WIN_EVENT_KEY, play)
  }

  undoMove(step = 1) {
    if (!this.history.length || this.player === 3) {
      return
    }
    const arr = this.history.splice(this.history.length - step, this.history.length)
    arr.forEach(({site})=> {
      const [x, y] = site
      this.result[x][y] = 0
    })
    if (step === 1) {
      this.player = this.player === 1 ? 2 : 1
    }
    if (this.history.length) {
      this.lastChess = this.history[this.history.length - 1]
      return
    }
    this.lastChess = null
  }

  restart() {
    this.history = []
    this.lastChess = null
    this.player = 1
    this.result = getResultVal()
  }


  @Builder playHint() {
    Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Text('')
        .width(2)
        .height(2)
        .borderRadius(50)
        .backgroundColor(Color.Red)
    }
    .width(this.lastChess?.size)
    .height(this.lastChess?.size)
    .position(this.lastChess?.position)
    .zIndex(500)
  }

  private moreBoard() {
    const width = this.context.width
    const gap = width / 16
    this.gap = gap
    const maxWidth = width - gap
    this.context.strokeStyle = "#C0A27B";
    this.context.lineWidth = .2
    const min = (gap / 1.75)
    const max = width - min - min
    const ra = (min / 2)
    drawRoundedRect(this.context, min, min, max, max, ra)
    drawGobang(this.context, gap, maxWidth)
  }

  private oneStep(x: number, y: number) {
    this.history.push(getChess(x, y, this.gap, this.history.length % 2 === 0, this.gap / 2))
    this.chessMedia.play()
    this.lastChess = this.history[this.history.length - 1]
    this.result[x][y] = this.player
    this.player = this.player === 1 ? 2 : 1
    const data = gobangCheck(x, y, this.result)
    if (data) {
      this.player = 3
      this.lastChess = null
      setTimeout(() => {
        this.handleWin(data.val, data.res)
      }, 50)
      console.log(`游戏结束${data.res === 1 ? '黑棋' : '白棋'}获胜`);
    }
  }

  private handleCanvasClick(e: ClickEvent) {
    if (this.player == 3 || this.disabled) {
      return;
    }
    const {gap} = this
    const gap2 = gap / 2
    let x = Math.floor(Math.floor(e.x + gap2) / gap) - 1
    let y = Math.floor(Math.floor(e.y + gap2) / gap) - 1
    x = Math.max(x, 0)
    y = Math.max(y, 0)
    if (this.result[x][y]) {
      return
    }
    this.result[x][y] = this.player
    this.oneStep(x, y)
    controller.emit(RESULT_CHANGE_EVENT_KEY, this.result, x, y)
  }
  build() {
    Stack() {
      Canvas(this.context)
        .backgroundColor($r('app.color.gobang_background'))
        .width('720lpx')
        .height('720lpx')
        .zIndex(0)
        .margin('-10lpx')
        .responseRegion({ x: '30lpx', y: '30lpx', width: '660lpx', height: '660lpx' })
        .onReady(() => {
          this.moreBoard()
        })
        .onClick((e) => {
          this.handleCanvasClick(e)
        })
        .opacity(.9)
      ForEach(this.history, (i: Chess) => {
        GobangChess({ item: i })
      }, (item) => item.key)
      if (this.lastChess) {
        this.playHint()
      }
    }
    .width('700lpx')
    .height('700lpx')
    .borderRadius(4)
    .margin('10lpx')
    .clip(true)
  }

}
