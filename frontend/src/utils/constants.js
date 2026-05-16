import UserData from "../views/plugin/UserData";

export const API_BASE_URL = import.meta.env.VITE_API_BASE_URL;
export const SERVER_URL = import.meta.env.VITE_SERVER_URL;
export const CLIENT_URL = import.meta.env.VITE_CLIENT_URL;
export const PAYPAL_CLIENT_ID = import.meta.env.VITE_PAYPAL_CLIENT_ID;
export const CURRENCY_SIGN = import.meta.env.VITE_CURRENCY_SIGN;

export const userId = UserData()?.user_id;
export const teacherId = UserData()?.teacher_id;
console.log(teacherId);
