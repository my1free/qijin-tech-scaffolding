package ${package}.service.test;

import static org.junit.Assert.*;
import static org.mockito.Mockito.*;
import org.junit.*;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.context.annotation.Bean;
import org.springframework.test.context.jdbc.Sql;

/**
 * 一个UT教程: https://zhuanlan.zhihu.com/p/39994880
 *
 * @author UnitTest
 * @date 2018/11/2
 * 开始做眼保健操：←_← ↑_↑ →_→ ↓_↓
 **/
public class ExampleTest extends BaseTest {

    @BeforeClass
    public static void beforeClass(){
        LOGGER.info("execute just once in the total life cycle");
    }

    @AfterClass
    public static void afterClass(){
        LOGGER.info("execute just once in the total life cycle");
    }

    @Before
    public void before(){
        LOGGER.info("execute every time before a @Test");
    }

    @After
    public void after(){
        LOGGER.info("execute every time after a @Test");
    }


    @Sql(scripts = {"/data/test.sql"})
    @Test
    public void test() {
        LOGGER.info("test");
    }
}