package hello.springmvc.basic;

import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

//@Slf4j
@RestController // 문자열 그대로 반환함. 페이지 소스 보기를 보면 알 수 있음, Rest API를 만들 때 핵심적인 컨트롤러
public class LogTestController {
  private final Logger log = LoggerFactory.getLogger(getClass()); // 이거 적기 귀찮으면 @Slf4j를 써보자.

  @RequestMapping("/log-test")
  public String logTest() {
    String name = "Spring";

    log.trace("trace log = {}", name); // {}, name은 치환 관계, 어떤 상태의 레벨인가?
    log.debug("debug log = {}", name); // 디버그 할 때 보는 것. (개발 서버 같은 곳에서)
    log.info("info log = {}", name); // 중요한 정보 로그
    log.warn("warn log = {}", name);  // 경고
    log.error("error log = {}", name); // 에러


    return "ok";

    //아래 메시지를 보면 다음과 같은 메시지가 있다.
    // 2025-10-12T11:29:38.827+09:00  INFO 8696 --- [springmvc] [nio-8080-exec-1] h.springmvc.basic.LogTestController      :  info log = Spring
    // nio-8080-exec-1 은 쓰레드를 의미 맨 오른쪽에 메시지있음.
  }
}
