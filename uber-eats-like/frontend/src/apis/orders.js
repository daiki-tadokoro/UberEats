import axios from "axios";
import { orders } from "../urls/index";

export const postOrder = (params) => {
  console.log("api内", params);
  return axios
    .post(orders, {
      line_food_ids: params.line_food_ids,
    })
    .then((res) => {
      console.log("res", res);
      return res.data;
    })
    .catch((e) => console.error(e));
};
