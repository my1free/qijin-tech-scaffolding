package ${package}.server.api;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import io.swagger.annotations.ApiOperation;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

/**
 * author SYSTEM
 */
@Controller
public class BaseController {

    private static final Logger LOGGER = LoggerFactory.getLogger("BASE");


    @GetMapping(value = "/")
    public String index(Model model) {
        return "index";
    }

    @ResponseBody
    @RequestMapping(value = "/health_check", method = RequestMethod.GET)
    @ApiOperation(value = "健康检查", notes = "http code 200 is ok")
    public String healthCheck() {
        LOGGER.info("check alive");
        return "Alive";
    }
}