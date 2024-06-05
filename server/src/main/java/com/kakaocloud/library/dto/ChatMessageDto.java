package com.kakaocloud.library.dto;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;

@Setter
@Getter
@Data
public class ChatMessageDto {
    private String id;
    private String from;
    private String message;
    private String timestamp;

    public ChatMessageDto() {
        Date date = new Date();
        SimpleDateFormat formatter = new SimpleDateFormat("a hh:mm");
        this.timestamp = formatter.format(date);
        this.message = "";
    }

    public ChatMessageDto(String message) {
        this();
        this.message = message;
    }

    public ChatMessageDto(String from, String message) {
        this();
        this.from = from;
        this.message = message;

        if("System".equals(from)) {
            this.id = "admin";
        }
    }

    public ChatMessageDto(String id, String from, String message) {
        this();
        this.id = id;
        this.from = from;
        this.message = message;
    }

}
