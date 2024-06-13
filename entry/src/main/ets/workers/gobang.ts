import worker, { ThreadWorkerGlobalScope } from '@ohos.worker';
import AI from "../ai/ai"
import config from '../ai/config'

const  ai = new AI()

const workerPort : ThreadWorkerGlobalScope = worker.workerPort;
workerPort.onmessage =function(e) {
  let d = e.data
  console.log('get moveMessage:: '+ JSON.stringify(d))
  if(d.type == "START") {
    const open = ai.start(d.first)
    workerPort.postMessage({
      type: 'board',
      data: open
    })
  } else if(d.type == "BEGIN") {
    var p = ai.begin()
    workerPort.postMessage({
      type: 'put',
      data: p
    })
  } else if(d.type == "GO") {
    var p = ai.turn(e.data.x, e.data.y)
    workerPort.postMessage({
      type: 'put',
      data: p
    })
  } else if(d.type == "BACKWARD") {
    ai.backward()
  } else if(d.type == "FORWARD") {
    ai.forward()
  } else if(d.type == "CONFIG") {
    if (d.searchDeep) config.searchDeep = d.searchDeep
    if (d.countLimit) config.countLimit = d.countLimit
    if (d.vcxDeep) config.vcxDeep = d.vcxDeep
    if (d.timeLimit) config.timeLimit = d.timeLimit
    if (d.spread !== undefined) config.spreadLimit = d.spread
  }
}
workerPort.onmessageerror = function ( e) {
  console.log('onmessageerror:' + e.data.toString())
}
workerPort.onerror = e => {
  console.log('onerror:' + e.message)
}
