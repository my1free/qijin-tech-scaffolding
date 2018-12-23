package ${package}.server.api;

import lombok.extern.slf4j.Slf4j;
import io.swagger.annotations.ApiOperation;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

/**
 * @author SYSTEM
 */
@RestController
@Slf4j
public class BaseController {

    @RequestMapping(value = "/health_check",method = RequestMethod.GET)
    @ApiOperation(value = "健康检查", notes = "http code 200 is ok")
    public String healthCheck() {
        log.info("check alive");
        return "Alive";
    }
}