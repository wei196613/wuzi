import { Chess } from './lib'

@Component
export struct GobangChess {
  @ObjectLink item: Chess

  build() {
    Text(this.item.context)
      .width(this.item.size)
      .height(this.item.size)
      .fontColor(this.item.fontColor)
      .fontSize(5)
      .textAlign(TextAlign.Center)
      .lineHeight(this.item.lineHeight - 5)
      .borderRadius(50)
      .radialGradient(this.item.radialGradient)
      .shadow(this.item.shadow)
      .position(this.item.position)
      .zIndex(100)
      .scale({ x: this.item.winIndex ? .9 : 1, y: this.item.winIndex ? .9 : 1 })
      .animation({ duration: 500, playMode: PlayMode.Alternate, curve: Curve.Smooth, iterations: -1 })
  }
}
