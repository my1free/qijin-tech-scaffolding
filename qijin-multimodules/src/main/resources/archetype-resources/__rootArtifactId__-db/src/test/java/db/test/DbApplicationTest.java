package ${package}.db.test;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.test.context.SpringBootTest;

import java.nio.charset.Charset;

/**
 * @author : UnitTest
 */

@SpringBootApplication
@MapperScan("${package}.db.dao")
@SpringBootTest
public class DbApplicationTest {

    public static void main(String[] args) {
        SpringApplication.run(DbApplicationTest.class, args);
    }
}
