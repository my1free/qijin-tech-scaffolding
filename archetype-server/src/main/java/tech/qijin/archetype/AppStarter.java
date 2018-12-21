package tech.qijin.archetype;

import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.PropertySource;
import org.springframework.retry.annotation.EnableRetry;
import org.springframework.scheduling.annotation.EnableAsync;

import java.util.Arrays;

@Slf4j
@SpringBootApplication(scanBasePackages = {"com.qijin.tech.archetype"})
@PropertySource("classpath:/META-INF/app.properties")
@EnableRetry
@EnableAsync
public class AppStarter {
    public static void main(String[] args) {
        SpringApplication.run(AppStarter.class, args);
        log.info("===== AppStarter started =====");
    }

    //服务启动后，加载所有 bean 定义，并打印。用于排查问题。如不需要，可注释掉。
    @Bean
    public CommandLineRunner print(ApplicationContext ctx) {
        return args -> {
            String[] beanNames = ctx.getBeanDefinitionNames();
            Arrays.sort(beanNames);
            for (String beanName : beanNames) {
                log.info("[starter] bean provided by spring boot : " + beanName);
            }
        };
    }

}
