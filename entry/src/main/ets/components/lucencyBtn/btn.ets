@Builder
export function lucencyBtn(content?: string | Resource, event?: (event?: ClickEvent) => void) {
  Text(content)
    .backgroundColor($r('app.color.gobang_background'))
    .fontSize('24vp')
    .lineHeight('32vp')
    .height('64vp')
    .width('64vp')
    .textAlign(TextAlign.Center)
    .fontColor($r('app.color.body_color'))
    .borderRadius('64vp')
    .margin('10vp')
    .onClick(event)
}
