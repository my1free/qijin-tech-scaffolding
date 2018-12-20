package ${package}.service.config;

import com.alibaba.druid.spring.boot.autoconfigure.DruidDataSourceBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;

import javax.sql.DataSource;


/**
 * 参考文章：https://medium.com/@d.lopez.j/spring-boot-mybatis-multiple-datasources-and-multiple-mappers-all-together-holding-hands-be74673c6a9f
 * https://github.com/alibaba/druid/tree/master/druid-spring-boot-starter
 * TODO: 这里强制使用Druid连接池，以后要弄成可配置的
 *
 * @author michealyang
 * @date 2018/11/28
 * 开始做眼保健操：←_← ↑_↑ →_→ ↓_↓
 **/
@Configuration
public class DatasourceConfiguration {
    public static final String PRIMARY_DATASOURCE = "primary";

    @Bean(name = PRIMARY_DATASOURCE)
    @Primary
    public DataSource dataSourceOne() {
        // Filled up with the properties specified about thanks to Spring Boot black magic
        return DruidDataSourceBuilder.create().build();
    }
}
