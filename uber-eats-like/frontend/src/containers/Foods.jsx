import React, { Fragment, useEffect, useReducer } from "react";

// reducers
import {
  initialState as foodsInitialState,
  foodsActionTypes,
  foodsRedeucer,
} from "../reducers/foods";

// api
import { fetchFoods } from "../apis/foods";

// 取得判断のためのstate
import { REQUEST_STATE } from "../constants";

export const Foods = ({ match }) => {
  const [foodsState, dispatch] = useReducer(foodsRedeucer, foodsInitialState);

  useEffect(() => {
    dispatch({ type: foodsActionTypes.FETCHING });
    fetchFoods(match.params.restaurantsId).then((data) => {
      dispatch({
        type: foodsActionTypes.FETCH_SUCCESS,
        payload: {
          foods: data.foods,
        },
      });
    });
  }, []);
  return (
    <Fragment>
      {foodsState.fetchState === REQUEST_STATE.LOADING ? (
        <Fragment>
          <p>ロード中...</p>
        </Fragment>
      ) : (
        <p>とりあえずあってるか確認</p>
      )}
    </Fragment>
  );
};
