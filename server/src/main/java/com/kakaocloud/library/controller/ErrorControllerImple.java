package com.kakaocloud.library.controller;

import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ErrorControllerImple implements ErrorController {
    @RequestMapping("/error")
    public ResponseEntity<String> handleError() {
        return new ResponseEntity<>("{ msg: error }", HttpStatus.FORBIDDEN);
    }
}
