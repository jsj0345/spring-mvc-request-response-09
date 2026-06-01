package hello.springmvc.basic.request;

import hello.springmvc.basic.HelloData;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.io.IOException;
import java.util.Map;

@Slf4j
@Controller
public class RequestParamController {

  /**
   * 반환 타입이 없으면서 이렇게 응답에 값을 직접 넣어버리면, view 조회x
   */
  @RequestMapping("/request-param-v1")
  public void requestParamV1(HttpServletRequest request, HttpServletResponse response)
    throws IOException {

    String username = request.getParameter("username");
    int age = Integer.parseInt(request.getParameter("age"));
    log.info("username={}, age={}", username, age);

    response.getWriter().write("ok");
  }


  /*
  문자열을 반환하면 ViewResolver에 의해서 물리적인 경로 이름을 완성시킬수 있다.
  따라서, 문자 자체를 내놓고싶으면 @ResponseBody를 활용하자.
  */
  @ResponseBody
  @RequestMapping("/request-param-v2")
  public String requestParamV2(@RequestParam("username") String memberName,
                               @RequestParam("age") int memberAge) {

    log.info("username={}, age={}", memberName, memberAge);
    return "ok";
  }

  @ResponseBody
  @RequestMapping("/request-param-v3")
  public String requestParamV3(
      @RequestParam String username,
      @RequestParam int age
  ) {
    log.info("username={}, age={}", username, age);
    return "ok";
  }

  @ResponseBody
  @RequestMapping("/request-param-v4")
  public String requestParamV4(String username, int age) {
    log.info("username={}, age={}", username, age);
    return "ok";
  }

  @ResponseBody
  @RequestMapping("/request-param-required")
  public String requestParamRequired(
      @RequestParam(required = true) String username,
      //@RequestParam(required = false) int age
      @RequestParam(required = false) Integer age
  ) {

    // required -> false 면 username, age에 대한 데이터가 없어도 문제 없음. (파라미터가 필수가 아님)
    // 만약 true면? 무조건 있어야한다. (파라미터가 필수임)
    // 둘다 false로 지정해도 Whitelable page가 나온다. 이러한 이유는 age가 int형이라 값이 없어도 null을 넣어줘야 하는데
    // 기본형이므로 넣어주지 못해서 Integer로 바꿔보자.
    // url에 username= 이렇게 해보자. (빈 문자가 들어감)

    log.info("username={}, age={}", username, age);
    return "ok";

  }

  @ResponseBody
  @RequestMapping("/request-param-default")
  public String requestParamDefault(
      @RequestParam(required = true, defaultValue = "guest") String username,
      @RequestParam(required = false, defaultValue = "-1") int age
  ) {

    // url에 username= 이렇게 입력해도 guest가 나옴.
    log.info("username={}, age={}", username, age);
    return "ok";
  }

  @ResponseBody
  @RequestMapping("/request-param-map")
  public String requestParamMap(@RequestParam Map<String, Object> paramMap) {

    log.info("username={}, age={}", paramMap.get("username"), paramMap.get("age"));
    return "ok";

  }

  @ResponseBody
  @RequestMapping("/model-attribute-v1")
  public String modelAttributeV1(@ModelAttribute HelloData helloData) {
    log.info("helloData = {}", helloData);

    return "ok";
  }

  @ResponseBody
  @RequestMapping("/model-attribute-v2")
  public String modelAttributeV2(HelloData helloData) {
    log.info("username = {}, age = {}", helloData.getUsername(), helloData.getAge());
    return "ok";
  }

}

