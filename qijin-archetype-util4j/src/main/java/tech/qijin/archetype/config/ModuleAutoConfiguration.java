package tech.qijin.archetype.config;

import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;

@Configuration
@EnableConfigurationProperties(ModuleProperties.class)
@Import(ModuleAutoConfiguration.class)
public class ModuleAutoConfiguration {
}
