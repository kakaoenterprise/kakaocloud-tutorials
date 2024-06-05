package com.kakaocloud.library.websocket;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.kakaocloud.library.dto.ChatMessageDto;
import com.kakaocloud.library.websocket.chat.ChatSession;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.autoconfigure.data.redis.RedisProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.data.redis.connection.Message;
import org.springframework.data.redis.connection.MessageListener;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.listener.PatternTopic;
import org.springframework.data.redis.listener.RedisMessageListenerContainer;
import org.springframework.data.redis.listener.adapter.MessageListenerAdapter;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import java.io.IOException;
import java.util.HashSet;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

@Component
@RequiredArgsConstructor
public class ChatHandler extends TextWebSocketHandler implements MessageListener {

    private static final String SYSTEM_NAME = "System";
    private static final String LOCAL_NAME = "LocalUser";
    private static final String SPECIAL_NAME = "Special";

    @NonNull
    private final Map<String, WebSocketSession> readySessions = new ConcurrentHashMap<>();

    @NonNull
    private final Map<String, ChatSession> sessions = new ConcurrentHashMap<>();
    private final ObjectMapper objectMapper = new ObjectMapper();
    private final RedisProperties redisProperties;
    private final StringRedisTemplate redisTemplate;
    private static final String TOPIC = "chat";
    @Override
    public void afterConnectionEstablished(@NonNull WebSocketSession session) throws Exception {

        // 외부 Redis 서버를 사용하지 않고 Embedded Redis를 사용할 경우, 다중 서버 구성 시 채팅 기능이 정상적으로 동작하지 않음.
        if("localhost".equals(redisProperties.getHost()) || "127.0.0.1".equals(redisProperties.getHost())) {
            sendMessageToSession(session, new ChatMessageDto(SYSTEM_NAME, "내장 Redis를 사용하고 있습니다. 기능이 정상적으로 동작하지 않을 수 있습니다."));
        }

        readySessions.put(session.getId(), session);
        sendMessageToSession(session, new ChatMessageDto(SYSTEM_NAME, "채팅을 통해 사용하실 닉네임을 5글자 이내로 입력해주세요."));
    }

    @Override
    protected void handleTextMessage(@NonNull WebSocketSession session, @NonNull TextMessage message) throws Exception {
        if(readySessions.containsKey(session.getId())) {
            handleReadyChatMessage(session, message);
            return;
        }
        if(sessions.containsKey(session.getId())) {
            handleChatMessage(session, message);
            return;
        }
        session.close();
    }

    private void handleReadyChatMessage(@NonNull WebSocketSession session, @NonNull TextMessage message) throws IOException {
        ChatMessageDto chatMessage = objectMapper.readValue(message.getPayload(), ChatMessageDto.class);;

        sendMessageToSession(session, new ChatMessageDto(LOCAL_NAME, chatMessage.getMessage()));

        if(chatMessage.getMessage().isEmpty() || chatMessage.getMessage().length() > 5) {
            sendMessageToSession(session, new ChatMessageDto(SYSTEM_NAME, "[입력 형식 문제] 글자 수를 확인하고 다시 입력해주세요."));
            return;
        }
        if(chatMessage.getMessage().contains(" ")) {
            sendMessageToSession(session, new ChatMessageDto(SYSTEM_NAME, "[입력 형식 문제] 특수기호가 있습니다. 확인하고 다시 입력해주세요."));
            return;
        }
        if(chatMessage.getMessage().toUpperCase(Locale.ROOT).equals("SYSTEM") || chatMessage.getMessage().toUpperCase(Locale.ROOT).equals("LOCALUSER")) {
            sendMessageToSession(session, new ChatMessageDto(SYSTEM_NAME, "[예약 키워드 문제] 사용할 수 없는 닉네임입니다. 다른 닉네임을 입력해주세요."));
            return;
        }

        sendMessageToSession(session, new ChatMessageDto(SYSTEM_NAME, "닉네임을 \"%s\"으로 설정합니다.".formatted(chatMessage.getMessage())));
        readySessions.remove(session.getId());
        var user = ChatSession.builder()
                .nickname(chatMessage.getMessage())
                .session(session)
                .build();
        sessions.put(session.getId(), user);
        sendChat(new ChatMessageDto("admin", SPECIAL_NAME, "%s님이 채팅방에 등장했습니다.".formatted(user.getNickname())));
    }

    private void handleChatMessage(@NonNull WebSocketSession session, @NonNull TextMessage message) throws JsonProcessingException {
        ChatSession user = sessions.get(session.getId());
        ChatMessageDto chatMessage = objectMapper.readValue(message.getPayload(), ChatMessageDto.class);
        chatMessage.setFrom(user.getNickname());
        chatMessage.setId(session.getId());
        sendChat(chatMessage);
    }


    @Override
    public void afterConnectionClosed(WebSocketSession session, @NonNull CloseStatus status) throws IOException {
        if(sessions.containsKey(session.getId())) {
            ChatSession user = sessions.get(session.getId());
            sessions.remove(session.getId());
            sendChat(new ChatMessageDto("admin", SPECIAL_NAME, "%s님이 퇴장하셨습니다.".formatted(user.getNickname())));
            return;
        }
        if(readySessions.containsKey(session.getId())) {
            readySessions.remove(session.getId());
            return;
        }
    }

    private void sendChat(ChatMessageDto messageDto) throws JsonProcessingException {
        String response = objectMapper.writeValueAsString(messageDto);
        redisTemplate.convertAndSend(TOPIC, response);
    }

    @Override
    public void onMessage(@NonNull Message message, byte[] pattern) {
        try {
            ChatMessageDto chatMessage = objectMapper.readValue(message.getBody(), ChatMessageDto.class);
            String localUser = chatMessage.getId();
            chatMessage.setId(chatMessage.getId().substring(0,5));

            for (ChatSession s : sessions.values()) {
                try {
                    if(s.getSession().getId().equals(localUser)) {
                        sendMessageToSession(s.getSession(), new ChatMessageDto(LOCAL_NAME, LOCAL_NAME, chatMessage.getMessage()));
                    }
                    else {
                        sendMessageToSession(s.getSession(), chatMessage);
                    }
                } catch (IOException e) {
                    throw new RuntimeException(e);
                }
            }
        } catch (IOException e) {
            throw new RuntimeException(e);
        };
    }

    private void sendMessageToSession(WebSocketSession session, ChatMessageDto chatMessageDto) throws IOException {
        session.sendMessage(
                new TextMessage(objectMapper.writeValueAsString(chatMessageDto))
        );
    }

    @Bean
    RedisMessageListenerContainer container(RedisConnectionFactory connectionFactory,
                                            MessageListenerAdapter listenerAdapter) {
        RedisMessageListenerContainer container = new RedisMessageListenerContainer();
        container.setConnectionFactory(connectionFactory);
        container.addMessageListener(listenerAdapter, new PatternTopic(TOPIC));
        return container;
    }

    @Bean
    MessageListenerAdapter listenerAdapter(ChatHandler subscriber) {
        return new MessageListenerAdapter(subscriber);
    }
}