import { Gobang, RESTART_EVENT_KEY, UNDO_EVENT_KEY, controller, WIN_EVENT_KEY  } from '../components/gobang'
import { lucencyBtn } from '../components/lucencyBtn'
import { gameOver } from '../utils/gameOver'

@Entry
@Component
struct Both {
  aboutToAppear() {
    controller.on(WIN_EVENT_KEY, this.gameOver)
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
  build() {
    Flex({ direction: FlexDirection.Column }) {
      Column() {
        Navigation()
          .titleMode(NavigationTitleMode.Mini)
          .width('100%')
          .height('56vp')
          .margin({top: '24vp'})
          .title('双人对战')
      }
      .flexGrow(1)
      .width('100%')
      Gobang({disabled: false})
      Flex({justifyContent: FlexAlign.Center}) {
        lucencyBtn('悔棋', () => {
          controller.emit(UNDO_EVENT_KEY)
        })
        lucencyBtn('重开', () => {
          controller.emit(RESTART_EVENT_KEY)
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