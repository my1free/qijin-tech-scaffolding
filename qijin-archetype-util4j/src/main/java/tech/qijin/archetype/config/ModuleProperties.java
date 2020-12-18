package tech.qijin.archetype.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

@Data
@ConfigurationProperties(prefix = "util4j.util4j-module")
public class ModuleProperties {
}
