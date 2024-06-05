import React, { useState, useEffect, useRef } from 'react';
import { URL } from '../../config';
import './ChatWindow.css';

export const ChatWindow = () => {
    const [messages, setMessages] = useState([]);
    const [inputMessage, setInputMessage] = useState('');
    const messagesEndRef = useRef(null);
    const websocket = useRef(null);

    useEffect(() => {
        const wsUrl = URL.BASE.replace("http://", "ws://").replace("https://", "wss://") + "/api/websocket/chat";
        websocket.current = new WebSocket(wsUrl);

        websocket.current.onopen = () => console.log('Chat Connected');

        websocket.current.onmessage = (event) => {
            const message = JSON.parse(event.data);
            setMessages((prevMessages) => {
                const newMessages = [...prevMessages, message];
                return newMessages.length > 200 ? newMessages.slice(1) : newMessages;
            });
        };

        websocket.current.onclose = () => console.log('Chat Disconnected');

        const wsCurrent = websocket.current;
        return () => wsCurrent.close();
    }, []);

    useEffect(() => {
        messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
    }, [messages]);

    const sendMessage = () => {
        if (inputMessage.trim()) {
            websocket.current.send(JSON.stringify({ message: inputMessage }));
            setInputMessage('');
        }
    };

    const handleKeyPress = (event) => {
        if (event.key === 'Enter') {
            sendMessage();
        }
    };

    const isProfileIcon = (from) => {
        return !(from === "LocalUser" || from === "Special");
    }

    const getMessageStyle = (from) => {
        if(from === "LocalUser") {
            return {
                alignSelf: 'flex-end',
                backgroundColor: '#CEE4FF',
                borderRadius: '10px 10px 0 10px',
                textAlign: 'left',
                padding: '10px 16px',
                maxWidth: '60%',
                marginLeft: '48px'
            }
        }
        if (from === "Special") {
            return {
                backgroundColor: '#555555', // 더 어두운 배경색
                borderRadius: '10px 10px 10px 10px',
                textAlign: 'center',
                padding: '5px 16px',
                maxWidth: '60%',
                fontSize: '10px',
                color: '#DDDDDD', // 덜 하얀 텍스트
                display: 'flex',
                justifyContent: 'center',
                alignItems: 'center',
                margin: '0 auto'
            }
        }


        return {
            alignSelf: 'flex-start',
            backgroundColor: '#F5F5F5',
            borderRadius: '10px 10px 10px 0',
            textAlign: 'left',
            padding: '10px 16px',
            maxWidth: '60%',
            marginLeft: '48px'
        }

    }

    const getProfileIcon = (from) => from === 'System' ? "/assets/profiles/system-icon.png" : "/assets/profiles/user-icon.png";

    const renderMessage = (msg, index) => {
        const previousMessage = messages[index - 1];
        const nextMessage = messages[index + 1];
        const isSameUser = previousMessage && previousMessage.from === msg.from && previousMessage.id === msg.id;

        const isLastInGroup = msg.from !== "Special" && (!nextMessage || nextMessage.from === "Special" ||
            (nextMessage.timestamp.slice(0, 5) !== msg.timestamp.slice(0, 5)));

        const messageStyle = getMessageStyle(msg.from);

        const timestampStyle = {
            alignSelf: msg.from === "LocalUser" ? 'flex-end' : 'flex-start',
            marginRight: msg.from === "LocalUser" ? '2px' : '0',
            marginLeft: msg.from !== "LocalUser" ? '50px' : '0',
            marginTop: '4px'
        };

        return (
            <div key={index} style={{ display: 'flex', flexDirection: 'column', marginBottom: '16px' }}>
                {!isSameUser && isProfileIcon(msg.from) && (
                    <div className="profile">
                        <div className="profileIcon" style={{ backgroundImage: `url(${getProfileIcon(msg.from)})` }}></div>
                        <div className="profileName">{msg.from === "System" ? msg.from : `${msg.from}(${msg.id})`}</div>
                    </div>
                )}
                <div style={messageStyle}>{msg.message}</div>
                {isLastInGroup && <div className="timestamp" style={timestampStyle}>{msg.timestamp}</div>}
            </div>
        );
    };


    return (
        <div className="chatContainer">
            <div className="chatheader">
                <div className="chatheaderTitle">채팅하기</div>
                <div className="chatheaderIcon">
                    {}
                </div>
            </div>
            <div className="messagesContainer">
                {messages.map(renderMessage)}
                <div ref={messagesEndRef} />
            </div>
            <div className="inputContainer">
                <input
                    type="text"
                    value={inputMessage}
                    onChange={(e) => setInputMessage(e.target.value)}
                    onKeyPress={handleKeyPress}
                    className="input"
                    placeholder="텍스트를 입력해주세요."
                />
                <button onClick={sendMessage} className="button">입력</button>
            </div>
        </div>
    );
};

export default ChatWindow;
