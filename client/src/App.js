import { Route, Routes } from "react-router-dom";
import { MainPage } from "./pages/MainPage/MainPage";
import { DetailPage } from "./pages/DetailPage/DetailPage";
import { Error } from "./pages/Error/Error";
import { SearchPage } from "./pages/SearchPage/SearchPage";
import { ChatWindow } from "./components/ChatWindow/ChatWindow";
import { ChatIcon } from "./components/ChatIcon/ChatIcon"
import { useState, useEffect } from 'react';
import { API } from './config';

export const App = () => {
  const [isChatOpen, setIsChatOpen] = useState(false);
  const [showChatIcon, setShowChatIcon] = useState(false);

  const toggleChat = () => {
    setIsChatOpen(!isChatOpen);
  };

  useEffect(() => {
      const fetchChatStatus = async () => {
          try {
              const response = await fetch(API.GET_CHAT_STATUS);
              const data = await response.json();
              if (data.status === true) {
                  console.log("Chat is enabled");
                  setShowChatIcon(true);
              }
              else {
                  console.log("Chat is disabled");
              }
          } catch (error) {
              console.error('Error fetching chat status:', error);
          }
      };

      fetchChatStatus().then(r => "");
      }, []);

  return (
      <>
        <Routes>
          <Route path='' element={<MainPage />} />
          <Route path='/index.html' element={<MainPage />} />
          <Route path="/detail/:bookId" element={<DetailPage />} />
          <Route path="/result/:type/:keyword" element={<SearchPage />} />
          <Route path="/*" element={<Error />} />
        </Routes>
        {isChatOpen && <ChatWindow />}
          {showChatIcon && <ChatIcon toggleChat={toggleChat} />}
      </>
  );
};