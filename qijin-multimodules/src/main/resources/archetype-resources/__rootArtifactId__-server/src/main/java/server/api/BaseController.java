package ${package}.server.api;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class BaseController {

    @RequestMapping("/health_check")
    @ResponseBody
    public String healthCheck() {
        return "Alive";
    }
}