package com.tech.qijin.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequestMapping("/qijin/api")
public class HealthController {


    @RequestMapping("/health")
    public String health() {
        log.info("health check");
        return "SUCCESS";
    }

}
