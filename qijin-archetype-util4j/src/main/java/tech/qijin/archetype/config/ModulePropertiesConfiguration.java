package tech.qijin.archetype.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.springframework.context.annotation.PropertySource;

@Configuration
public class ModulePropertiesConfiguration {
    @Profile("dev")
    @Configuration
    @PropertySource("classpath:util4j-module-dev.properties")
    public static class DevConfiguration {
    }

    @Profile("test")
    @Configuration
    @PropertySource("classpath:util4j-module-test.properties")
    public static class TestConfiguration {
    }

    @Profile("prod")
    @Configuration
    @PropertySource("classpath:util4j-module-prod.properties")
    public static class ProdConfiguration {
    }

    @Profile("stress")
    @Configuration
    @PropertySource("classpath:util4j-module-stress.properties")
    public static class StressConfiguration {
    }

    @Profile("staging")
    @Configuration
    @PropertySource("classpath:util4j-module-staging.properties")
    public static class StagingConfiguration {
    }
}
