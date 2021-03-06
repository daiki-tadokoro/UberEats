import { REQUEST_STATE } from "../constants";

export const initialState = {
  fetchState: REQUEST_STATE.INITIAL, // 取得状況
  postState: REQUEST_STATE.INITIAL, // 登録状況
  lineFoodsSummary: null, // 仮注文データ
};

export const lineFoodsActionTypes = {
  FETCHING: "FETCHING",
  FETCH_SUCCESS: "FETCH_SUCCESS",
  POSTING: "POSTING",
  POST_SUCCESS: "POST_SUCCESS",
};

export const lineFoodsReducer = (state, action) => {
  switch (action.type) {
    case lineFoodsActionTypes.FETCHING:
      console.log("action1", action);
      return {
        ...state,
        fetchState: REQUEST_STATE.LOADING,
      };
    case lineFoodsActionTypes.FETCH_SUCCESS:
      console.log("action2", action);
      return {
        fetchState: REQUEST_STATE.OK,
        lineFoodsSummary: action.payload.lineFoodsSummary,
      };
    case lineFoodsActionTypes.POSTING:
      console.log("action3", action);
      return {
        ...state,
        postState: REQUEST_STATE.LOADING,
      };
    case lineFoodsActionTypes.POST_SUCCESS:
      console.log("action4", action);
      return {
        ...state,
        postState: REQUEST_STATE.OK,
      };
    default:
      console.log("action5", action);
      throw new Error();
  }
};
