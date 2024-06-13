export function drawRoundedRect(ctx: CanvasRenderingContext2D, x: number, y: number, width: number, height: number, radius: number) {
  ctx.beginPath();
  ctx.moveTo(x + radius, y);
  ctx.lineTo(x + width - radius, y);
  ctx.arcTo(x + width, y, x + width, y + radius, radius);
  ctx.lineTo(x + width, y + height - radius);
  ctx.arcTo(x + width, y + height, x + width - radius, y + height, radius);
  ctx.lineTo(x + radius, y + height);
  ctx.arcTo(x, y + height, x, y + height - radius, radius);
  ctx.lineTo(x, y + radius);
  ctx.arcTo(x, y, x + radius, y, radius);
  ctx.stroke();
}
/**
 * 画栅格棋盘
 * */
export function drawGobang(ctx: CanvasRenderingContext2D, gap: number, maxWidth: number) {
  for (let i = 1; i <= 15; i++) {
    ctx.beginPath()
    ctx.moveTo(i * gap, maxWidth)
    ctx.lineTo(i * gap, gap)
    ctx.moveTo(gap, i * gap)
    ctx.lineTo(maxWidth, i * gap)
    ctx.stroke()
  }
  ctx.arc(8 * gap, 8 * gap, 2, 0, 6.28)
  const gap4 = gap * 4
  const gap8 = gap * 8
  const gap12 = gap * 12
  drawArc(ctx, gap4, gap4)
  drawArc(ctx, gap4, gap12)
  drawArc(ctx, gap12, gap4)
  drawArc(ctx, gap12, gap12)
  drawArc(ctx, gap8, gap8)

}
export function drawArc(ctx: CanvasRenderingContext2D,x: number, y: number) {
  ctx.beginPath()
  ctx.arc(x, y, 1.5, 0, 6.28)
  ctx.fill()
}
/*
 * 初始化棋子
 * */
export function getChess(x: number, y: number, gap: number, single: boolean, gap2: number) {
  return new Chess({
    context: '',
    key: `${x}-${y}`,
    size: gap * .9,
    site: [x, y],
    lineHeight: gap2,
    fontColor: single ? Color.White : Color.Black,
    position: { x: calcPositon(x, gap), y: calcPositon(y, gap) },
    shadow: { radius: 0, offsetY: 1, offsetX: 1, color: 0x00006e },
    radialGradient: {
      center: [gap2],
      colors: [single ? [0x9E9E9E, -1] : [0xe4e4e4, 0.1], [single ? 0x000000 : 0xb7aaaa, 1]],
      radius: '50%'
    }
  })
}

export function calcPositon(val: number, gap: number) {
  return (val + .33) * gap
}

export function getResultVal() {
  return new Array(16).fill(0).map(() => new Array(16).fill(0))
}

@Observed export class Chess extends Object {
  key: string
  shadow: Parameters<TextAttribute['shadow']>[0]
  fontColor: ResourceColor
  position: Position
  size: number
  radialGradient: Parameters<TextAttribute['radialGradient']>[0]
  context: string
  site: number[]
  lineHeight: number
  winIndex: number

  constructor(config: Partial<Chess>) {
    super()
    Object.assign(this, config)
  }
}
