package hello.springmvc.basic.requestmapping;

import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.*;

@Slf4j
@RestController // 반환 값으로 뷰를 찾는 것이 아니라, HTTP 메시지 바디에 바로 입력한다.
// 따라서 실행 결과로 ok 메세지를 받을 수 있다. @ResponseBody와 관련이 있는데, 더 자세한건 뒤에서!
public class MappingController {

  //private Logger log = LoggerFactory.getLogger(getClass());

  @RequestMapping(value = {"/hello-basic", "hello-go"}) // 두개 중에 아무거나 하나 선택해서 url 입력 가능
  public String helloBasic() {
    log.info("helloBasic");
    return "ok";
  }

  @RequestMapping(value = "/mapping-get-v1", method = RequestMethod.GET)
  public String mappingGetV1() {
    log.info("mappingGetV1");
    return "ok";
  }

  /**
   * 편리한 축약 애노테이션 (코드보기)
   * @GetMapping
   * @PostMapping
   * @PutMapping
   * @DeleteMapping
   * @PatchMapping
   */

  @GetMapping("/mapping-get-v2") // 어노테이션 안으로 들어가면 method = {RequestMethod.GET} 임을 볼 수 있음.
  public String mappingGetV2() {
    log.info("mapping-get-v2");
    return "ok";
  }

  /**
   * PathVariable 사용
   * 변수명이 같으면 생략 가능
   * @PathVariable("userId") String userId -> @PathVariable userId
   * /mapping/userA
   */

  @GetMapping("/mapping/{userId}") // URL 경로의 어떤 값을 템플릿 형식으로 쓸 수 있음. 여기 있는 값을 @PathVariable이라는 걸로 꺼내가지고 사용할 수 있음.
  public String mappingPath(@PathVariable String userId)  {
    // @GetMapping에 있는 템플릿 형식의 변수명과 매개변수 명이 서로 같으면
    // @PathVariable String userId 이렇게 써도 코드는 잘 돌아감
    // @PathVariable("userId") String data
    log.info("mappingPath userId={}", userId);
    return "ok";
  }

  @GetMapping("/mapping/users/{userId}/orders/{orderId}")
  public String mappingPath(@PathVariable String userId, @PathVariable Long orderId) {
    log.info("mappingPath userId={}, orderId={}", userId, orderId);
    return "ok";
  }

  /**
   * 파라미터로 추가 매핑
   * params="mode",
   * params="!mode"
   * params="mode=debug"
   * params="mode!=debug"
   * params={"mode=debug", "data=good"}
   */

  @GetMapping(value = "/mapping-param", params = "mode=debug")
  public String mappingParam() {
    log.info("mappingParam");
    return "ok";
  }

  /**
   * 특정 헤더로 추가 매핑
   * headers="mode",
   * headers="!mode",
   * headers="mode=debug"
   * headers="mode!=debug"
   */
  @GetMapping(value = "/mapping-header", headers = "mode=debug")
  public String mappingHeader() { // 포스트맨에서 header에 key를 mode, value를 debug 추가하면 실행 된다.
    log.info("mappingHeader");
    return "ok";
  }

  /**
   * Content-Type 헤더 기반 추가 매핑 Media Type
   * consumes="application/json"
   * consumes="!application/json"
   * consumes="application/*"
   * consumes="*\/*"
   * MediaType.APPLICATION_JSON_VALUE
   */

  @PostMapping(value = "/mapping-consume", consumes = "application/json")
  public String mappingConsumes() {
    log.info("mappingConsumes");
    return "ok";
  }

  /**
   * Accept 헤더 기반 Media Type
   * produces = "text/html"
   * produces = "!text/html"
   * produces = "text/*"
   * produces = "*\/*"
   */

  @PostMapping(value = "/mapping-produce", produces = "text/html")
  public String mappingProduces() {
    log.info("mappingProduces");
    return "ok"; // postman에서 Header에 있는 Accept 확인
  }

}

