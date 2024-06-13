import router from '@ohos.router'
import process from '@ohos.process'
import { SettingDialog } from '../components/setting'

@Extend(Button) function btnStyle() {
  .width('576lpx')
  .margin({top: '36lpx', right: '72lpx', bottom: '36lpx', left: '72lpx'})
  .opacity(.95)
  .backgroundColor($r('app.color.gobang_background'))
  .fontColor($r('app.color.body_color'))
  .fontSize('24vp')
  .height('64vp')
}

@Entry
@Component
struct Index {
  @StorageProp('setting_bg') bg: string = ''
  aboutToAppear() {
    getContext(this)

  }
  settingDialog = new CustomDialogController({
    builder: SettingDialog({}),
    autoCancel: false
  })

  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center }) {
      Button('双人对战')
        .btnStyle()
        .onClick(() => {
          router.pushUrl({ url: 'pages/both' })
        })
      Button('简单人机')
        .btnStyle()
        .onClick(() => {
          router.pushUrl({ url: 'pages/ai', params: { grade: 0 } })
        })
      Button('普通人机')
        .btnStyle()
        .onClick(() => {
          router.pushUrl({ url: 'pages/ai', params: { grade: 1 } })
        })
      Button('困难人机')
        .btnStyle()
        .onClick(() => {
          router.pushUrl({ url: 'pages/ai', params: { grade: 2 } })
        })
      Button('游戏设置')
        .btnStyle()
        .onClick(() => {
          this.settingDialog.open()
        })
      Button('退出游戏')
        .btnStyle()
        .onClick(() => {
          new process.ProcessManager().exit(0)
        })
    }
    .width('100%')
    .height('100%')
    .backgroundImage(this.bg || $r('app.media.bg'), ImageRepeat.NoRepeat)
    .backgroundImageSize(ImageSize.Cover)
    .backgroundImagePosition(Alignment.Center)
  }
}