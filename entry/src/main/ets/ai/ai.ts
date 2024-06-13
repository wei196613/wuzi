import m from './negamax.js'
import R from './role.js'
import zobrist from './zobrist.js'
import config from './config.js'
import board from './board.js'
import opening from './opening.js'
import open1 from './open1.js'

class AI {

    //初始化,开始游戏
    // first 是否电脑先手
    // randomOpening 是否随机开局库，不随机的话电脑会直接下中间
    start(first) {
        if (first) {
            board.init(open1);
            return {
                board: open1
            }
        } else {
            board.init(15)
            return {
                board: undefined
            }
        }
    }

    //电脑下棋
    begin() {
        let p
        if (board.allSteps.length > 1) p = opening(board)
        p = p || m(undefined, config.searchDeep)
        board.put(p, R.com)
        return p
    }

    //下子并计算
    turn(x, y) {
        this.set(x, y, R.hum)
        return this.begin()
    }

    //只下子，不做计算
    set(x, y, r) {
        board.put([x, y], r)
    }

    //悔棋
    backward() {
        board.backward()
    }
    //悔棋
    forward() {
        board.forward()
    }
}

export default AI
