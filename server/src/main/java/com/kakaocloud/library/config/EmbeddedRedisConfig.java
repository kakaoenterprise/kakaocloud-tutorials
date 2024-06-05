package com.kakaocloud.library.config;

import jakarta.annotation.PostConstruct;
import jakarta.annotation.PreDestroy;
import org.springframework.boot.autoconfigure.data.redis.RedisProperties;
import org.springframework.context.annotation.Configuration;
import redis.embedded.RedisServer;

import java.io.IOException;


@Configuration
public class EmbeddedRedisConfig {

    private final RedisServer redisServer;

    public EmbeddedRedisConfig(RedisProperties redisProperties) throws IOException {
        this.redisServer = new RedisServer(redisProperties.getPort());
    }

    @PostConstruct
    public void postConstruct() {
        try {
            redisServer.start();
        }
        catch (IOException ignored) {
        }
    }

    @PreDestroy
    public void preDestroy() throws IOException {
        if (redisServer != null) {
            redisServer.stop();
        }
    }

}