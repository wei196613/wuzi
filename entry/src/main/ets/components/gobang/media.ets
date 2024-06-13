import media from '@ohos.multimedia.media'

export class PlayChessMedia {
  private  audioPlayer: media.AVPlayer
  private context: Context
  constructor(context: Context) {
    this.init()
    this.context = context
  }
  private  async init() {
    this.audioPlayer = await media.createAVPlayer()
    this.loadMediia()
  }
  private async loadMediia() {
    try {
      const file = await this.context.resourceManager.getRawFd('playChess.mp3')
      console.info("get file info succeed, the fd of file is " + file.fd);
      this.audioPlayer.url = 'fd://' + file.fd
      this.audioPlayer.loop = true
    }catch (err) {
      console.info('open fd failed err is' + err)
    }
  }
  public async play() {
    try {
      if (this.audioPlayer.state === 'paused') {
        await this.audioPlayer.reset()
      }
      if (this.audioPlayer.state === 'initialized') {
        await this.audioPlayer.prepare()
      }
      if (['completed', 'prepared'].includes(this.audioPlayer.state)) {
        await this.audioPlayer.play()
      }
    }catch (err) {
      console.error('播放失败 :' + err.message)
    }
  }
}