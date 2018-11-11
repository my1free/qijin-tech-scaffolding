package ${package}.server.api;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import io.swagger.annotations.ApiOperation;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

/**
 * author SYSTEM
 */
@RestController
public class BaseController {

    private static final Logger logger = LoggerFactory.getLogger("CHECK");

    @RequestMapping(value = "/health_check",method = RequestMethod.GET)
    @ApiOperation(value = "健康检查", notes = "http code 200 is ok")
    public String healthCheck() {
        logger.info("check alive");
        return "Alive";
    }
}
