package ${package}.rpcclient;

import com.alibaba.dubbo.config.annotation.Service;

@Service(timeout = 5000,
        retries = 3
)
public interface DemoService {
    String sayHello(String name);
}
