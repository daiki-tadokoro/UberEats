import axios from "axios";
import { restaurantsIndex } from "../urls/index";

export const fetchRestaurants = (restaurantId) => {
  return axios
    .get(restaurantsIndex)
    .then((res) => {
      return res.data;
    })
    .catch((e) => console.log(e));
};
