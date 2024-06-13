import { photoSelect } from '../../utils/photoSelect'
import picker from '@ohos.file.picker';
import fs from '@ohos.file.fs'
import { checkAccessToken } from '../../utils/checkAccessToken';
import promptAction from '@ohos.promptAction';

const copyFile = async (url: string, dest: string) => {
  try {
    await fs.open(dest, 0o100)
    await fs.copyFile(url, dest)
    return true
  } catch (err) {
    console.log('copyFile error:' + JSON.stringify(err))
  }
}

@Extend(Button) function btn() {
  .width('50%')
  .backgroundColor($r('app.color.transparency'))
  .fontColor($r('app.color.action_button_background'))
  .type(ButtonType.Normal)
}

@CustomDialog
export struct SettingDialog {
  controller: CustomDialogController
  @StorageLink('setting_bg') bg: string = ''
  @State bgurl: string = ''

  async updateBG() {
    const data = await photoSelect({ MIMEType: picker.PhotoViewMIMETypes.IMAGE_TYPE, maxSelectNumber: 1 })
    if (data) {
      console.log('photoSelect res: ' + JSON.stringify(data))
      this.bgurl = data.photoUris[0]
    }
  }

  getPermission() {
    return checkAccessToken('ohos.permission.WRITE_MEDIA')
  }

  async saveBG() {
    if (!this.bgurl) {
      promptAction.showToast({message: '请先上传图片'})
      return
    }
    if (!(await this.getPermission())) {
      promptAction.showToast({message: '没有存储文件权限保存失败'})
      return
    }
    const filesDir = getContext(this).filesDir
    const dest = filesDir + Date.now().toString(36) + this.bg.split('/').slice(-1)[0]
    const res = await  copyFile(this.bgurl, dest)
    if (res) {
      this.bg = dest
      this.controller.close()
    }
  }

  @Builder bgImage() {
    if (this.bgurl || this.bg) {
      Image(this.bgurl || this.bg).objectFit(ImageFit.Contain).width('100%').height('300lpx').margin({left: 24, right: 24, top: 12, bottom: 26})
    }
  }

  build() {
    Column() {
      Row() {
        Text('游戏设置').fontSize(16).fontWeight(800).width('100%').textAlign(TextAlign.Center)
      }.padding({ top: 26 })
      Row() {
        Text('自定义背景图:').fontSize(16).padding({ right: 6 })
        Button() {
          Row() {
            Image($r('app.media.upload')).width(20).height(20).margin({ left: 12 })
            Text(this.bgurl ? '重新上传' : '上传图片').fontColor(0xffffff).margin({ left: 5, right: 12 })
          }
        }.onClick(() => {
          this.updateBG()
        }).padding(6)
      }
      .margin({ top: 8, left: 24, right: 24 })
      this.bgImage()
      Row() {
        Button('取消')
          .btn()
          .onClick(() => {
            this.controller.close()
          })
        Button('保存')
          .btn()
          .onClick(() => {
            this.saveBG()
          })
      }
    }
  }
}