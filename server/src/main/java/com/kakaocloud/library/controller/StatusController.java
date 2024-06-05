package com.kakaocloud.library.controller;

import com.kakaocloud.library.dto.StatusDto;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.autoconfigure.data.redis.RedisProperties;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1.0/status")
@RequiredArgsConstructor
public class StatusController {

    private final RedisProperties redisProperties;
    @GetMapping(value = "/chat", produces = {MediaType.APPLICATION_JSON_VALUE})
    public ResponseEntity<StatusDto> getChatStatus() {
        StatusDto statusDto = StatusDto.builder()
                .status(!("localhost".equals(redisProperties.getHost()) || "127.0.0.1".equals(redisProperties.getHost())))
                .build();
        return new ResponseEntity<>(statusDto, HttpStatus.OK);
    }
}
