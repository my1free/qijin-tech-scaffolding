package ${package}.server.rpcserver.config;

import com.alibaba.dubbo.config.ApplicationConfig;
import com.alibaba.dubbo.config.ProtocolConfig;
import com.alibaba.dubbo.config.RegistryConfig;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class DubboConfiguration {

    @Value("${application.name}")
    private String applicationName;
    @Value("${registry.address}")
    private String registryAddress;
    @Value("${registry.client}")
    private String registryClient;
    @Value("${protocol.threads}")
    private String protocolThreads;
    @Value("${protocol.port}")
    private String protocolPort;

    @Bean
    public ApplicationConfig applicationConfig() {
        ApplicationConfig applicationConfig = new ApplicationConfig();
        applicationConfig.setName(applicationName);
        return applicationConfig;
    }

    @Bean
    public ProtocolConfig protocolConfig() {
        ProtocolConfig protocolConfig = new ProtocolConfig();
        protocolConfig.setThreads(Integer.valueOf(protocolThreads));
        protocolConfig.setPort(Integer.valueOf(protocolPort));
        return protocolConfig;
    }

    @Bean
    public RegistryConfig registryConfig() {
        RegistryConfig registryConfig = new RegistryConfig();
        registryConfig.setAddress(registryAddress);
        registryConfig.setClient(registryClient);
        return registryConfig;
    }
}