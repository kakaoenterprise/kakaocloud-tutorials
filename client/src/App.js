import { Route, Routes } from "react-router-dom";
import { MainPage } from "./Page/MainPage/MainPage";
import { DetailPage } from "./Page/DetailPage/DetailPage";
import { Error } from "./Page/Error/Error";
import { SearchPage } from "./Page/SearchPage/SearchPage";

export const App = () => {
  return (
   <Routes>
    <Route
      path=''
      element={<MainPage />}
    />
    <Route
      path='/index.html'
      element={<MainPage />}
    />
    <Route
      path="/detail/:bookId"
      element={<DetailPage />}
    />
    <Route
      path="/result/:type/:keyword"
      element={<SearchPage />}
    />
    <Route
      path="/*"
      element={<Error />}
    />
   </Routes>
  );
}