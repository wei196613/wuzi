/**
 * 悔棋回调事件
 */
export const UNDO_EVENT_KEY = Symbol('undo-event')
/*
 * 重开事件回调
 * */
export const RESTART_EVENT_KEY = Symbol('restart-event')
/*
 * 游戏结束
 * */
export const WIN_EVENT_KEY = Symbol('win-event')

/**
 * 棋盘变化事件
 * */
export const RESULT_CHANGE_EVENT_KEY = Symbol('result-change-event')

/**
 * 棋子切换
 * */
export const PLAYER_CHANGE_EVENT_KEY = Symbol('player-change-event')

/*
 * 落子事件
 * */
export const ONE_STEP_EVENT_KEY = Symbol('one-step-event')