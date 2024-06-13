export type UseControllerEventKey = string | Symbol

export class UseController {
  private eventMap = new Map<UseControllerEventKey, Array<(...args) => void>>()

  emit(key: UseControllerEventKey, ...args) {
    const event = this.eventMap.get(key)
    if (event && event.length) {
      event.forEach(e => {
        e(...args)
      })
    }
  }

  on(key: UseControllerEventKey, callback: (...args) => void) {
    const event = this.eventMap.get(key)
    if (event) {
      event.push(callback)
      return
    }
    this.eventMap.set(key, [callback])
  }

  destroy() {
    this.eventMap.clear()
  }
}

