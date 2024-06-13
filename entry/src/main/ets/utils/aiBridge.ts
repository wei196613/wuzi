import Worker  from '@ohos.worker';
let worker: Worker.ThreadWorker;

export const terminate = () => {
  worker.terminate()
}
export const createWorker = () => {
  worker = new Worker.ThreadWorker('entry/ets/workers/gobang.ts')
  worker.onerror = e => {
    console.log('worker.onerror: ' + e.message)
  }
}
export const start = async (aiFirst = false) => {
  return new Promise((resolve: (payload: number[]) => void, reject) => {
    worker.postMessage({
      type: "START",
      first: aiFirst
    });
    if (aiFirst) {
      resolve([7, 7])
    }
  })
};

export const move = async (position) => {
  return new Promise((resolve: (payload: number[]) => void, reject) => {
    console.log('moveMessage:' + JSON.stringify(position))
    worker.onmessage = (event) => {
      const { type, data } = event.data;
      if (type === 'put') {
        console.log(JSON.stringify(data), 'moveMessage')
        resolve(data);
      }
    };
    worker.postMessage({
      type: "GO",
      x: position[0],
      y: position[1]
    })
  })
};

export const updateConfig = (config: Object) => {
  worker.postMessage({
    type: "CONFIG",
    ...config
  })
}

export const end = async () => {
  return new Promise((resolve, reject) => {
    worker.onmessage = (event) => {
      const { action, payload } = event.data;
      if (action === 'end') {
        resolve(payload);
      }
    };
    worker.postMessage({
      action: 'end',
    });
  })
};

export const undo = async () => {
  return worker.postMessage({
    type: 'BACKWARD',
  });
};