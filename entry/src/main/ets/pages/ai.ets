import {
  controller,
  Gobang,
  ONE_STEP_EVENT_KEY,
  RESTART_EVENT_KEY,
  RESULT_CHANGE_EVENT_KEY,
  UNDO_EVENT_KEY,
  WIN_EVENT_KEY
} from '../components/gobang'
import { lucencyBtn } from '../components/lucencyBtn'
import { createWorker, move, start, terminate, undo, updateConfig } from '../utils/aiBridge'
import { gameOver, whoFirst } from '../utils/gameOver'
import router from '@ohos.router'
import promptAction from '@ohos.promptAction'

const gradeConfig = [
  { title: '简单人机', config: { searchDeep: 2, vcxDeep: 4 } },
  { title: '普通人机', config: { searchDeep: 4, vcxDeep: 5 } },
  { title: '困难人机', config: { searchDeep: 6, vcxDeep: 6 } }
]

@Entry
@Component
struct Ai {
  @State gobangDisabled: boolean = false
  isFirst = 0
  title = ''

  aboutToAppear() {
    createWorker()
    this.updateConfig()
    controller.on(WIN_EVENT_KEY, (val) => this.gameOver(val))
    controller.on(RESULT_CHANGE_EVENT_KEY, (res, x, y) => this.computerAI(res, [x, y]))
    this.setFirst()
  }

  updateConfig() {
    const { grade = 0 } = router.getParams() as { grade: number }
    const config = gradeConfig[grade]
    this.title = config.title
    updateConfig(config.config)
  }

  async setFirst() {
    const { index } = await whoFirst()
    this.isFirst = index
    this.reset()
  }

  async reset() {
    this.gobangDisabled = false
    controller.emit(RESTART_EVENT_KEY)
    const res = await start(this.isFirst === 0)
    if (res) {
      const [x, y] = res
      controller.emit(ONE_STEP_EVENT_KEY, x, y)
    }
  }

  async computerAI(res, po) {
    this.gobangDisabled = true
    const [x, y] = (await move(po))
    controller.emit(ONE_STEP_EVENT_KEY, x, y)
    this.gobangDisabled = false
  }

  async gameOver(val: number) {
    const {index} = await gameOver(val)
    if (index !== 0) {
      controller.emit(RESTART_EVENT_KEY)
    }
  }

  aboutToDisappear() {
    controller.destroy()
  }

  undo() {
    if (this.gobangDisabled) {
      promptAction.showToast({
        message: '人机思考中',
        duration: 1
      })
      return
    }
    controller.emit(UNDO_EVENT_KEY, 2)
    undo()
  }

  build() {
    Flex({ direction: FlexDirection.Column }) {
      Column() {
        Navigation()
          .titleMode(NavigationTitleMode.Mini)
          .width('100%')
          .height('56vp')
          .margin({ top: '24vp' })
          .title(this.title)
        if (this.gobangDisabled) {
          Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
            Image($r('app.media.Loading')).height('24vp')
            Text('人机思考中。。。').fontSize('24vp')
          }
        }
      }
      .flexGrow(2)
      .width('100%')

      Gobang({ disabled: this.gobangDisabled })
      Flex({ justifyContent: FlexAlign.Center }) {
        lucencyBtn('悔棋', () => {
          this.undo()
        })
        lucencyBtn('重开', () => {
          this.reset()
        })
      }
      .flexGrow(1)
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundImage($r('app.media.bg'), ImageRepeat.NoRepeat)
    .backgroundImageSize(ImageSize.Cover)
    .backgroundImagePosition(Alignment.Center)
  }
}