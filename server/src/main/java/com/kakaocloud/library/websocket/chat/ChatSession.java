package com.kakaocloud.library.websocket.chat;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import org.springframework.web.socket.WebSocketSession;

@Getter
@Setter
@Builder
public class ChatSession {
    @Builder.Default
    private String nickname = "unknown";
    private final WebSocketSession session;
}
