package ${package}.server.rpcserver;

import ${package}.rpcclient.DemoService;
import com.alibaba.dubbo.config.annotation.Service;

@Service(timeout = 1000)
public class DemoServiceImpl implements DemoService {
    public String sayHello(String name) {
        return "Hello " + name;
    }
}
