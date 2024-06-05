import React from 'react';
import './ChatIcon.css';

export const ChatIcon = ({ toggleChat }) => {
    return (
        <button onClick={toggleChat} className="chat-button">
            <div className="chat-icon"></div>
            <div className="chat-text">채팅하기</div>
        </button>
    );
};
