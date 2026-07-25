# Spring MVC 핵심 기능 복습

## 1. 운영 코드에서 로깅을 사용하는 이유

개발 중에는 `System.out.println()`으로 값을 확인할 수 있지만, 운영 환경의 기록 수단으로는 부족하다.

로그에는 메시지 외에도 시간, 실행 스레드, 클래스, 심각도 같은 정보가 함께 남는다. 출력 위치와 보관 정책도 콘솔, 파일, 외부 수집 시스템 등으로 바꿀 수 있다.

Spring Boot 프로젝트에서는 보통 SLF4J API를 통해 로그를 작성하고 실제 출력은 연결된 로깅 구현체가 담당한다.

```java
@Slf4j
@RestController
class LogController {

    @GetMapping("/internal/log-check")
    String check() {
        String requestId = "req-42";

        log.debug("requestId={}", requestId);
        log.info("log endpoint called");

        return "ok";
    }
}
```

### 로그 레벨

일반적인 심각도 순서는 다음과 같이 이해했다.

```text
TRACE → DEBUG → INFO → WARN → ERROR
```

설정한 기준보다 상세한 로그는 출력하지 않는다. 예를 들어 INFO 수준에서는 DEBUG와 TRACE가 보이지 않는다.

```properties
logging.level.root=info
logging.level.hello.springmvc=debug
```

패키지별로 수준을 다르게 두면 애플리케이션 전체의 로그를 과도하게 늘리지 않고 필요한 영역만 자세히 볼 수 있다.

### 문자열 연결을 피하는 이유

```java
log.debug("result=" + result);
```

DEBUG 로그가 꺼져 있어도 문자열 결합은 먼저 실행될 수 있다.

```java
log.debug("result={}", result);
```

자리표시자 방식은 해당 로그를 실제로 출력할 때 값을 조합하므로 불필요한 연산을 줄이는 데 유리하다.

### 주의할 점

- 비밀번호, 인증 토큰, 주민등록번호 같은 민감 정보는 남기지 않는다.
- 요청 본문 전체를 무조건 기록하면 개인정보와 저장 공간 문제가 생길 수 있다.
- ERROR 로그를 예외 처리 대신 사용하면 안 된다.
- 동일한 오류를 여러 계층에서 반복 기록하면 원인 파악이 오히려 어려워질 수 있다.

---

## 2. 요청 매핑은 URL만 보는 기능이 아니다

Spring MVC는 요청 경로와 HTTP 메서드 등의 조건을 이용해 실행할 컨트롤러 메서드를 찾는다.

```java
@RestController
@RequestMapping("/catalog")
class CatalogController {

    @GetMapping("/items/{itemId}")
    String find(@PathVariable long itemId) {
        return "item=" + itemId;
    }
}
```

클래스의 공통 경로와 메서드 경로가 합쳐져 최종 주소가 된다.

```text
/catalog + /items/{itemId}
→ /catalog/items/{itemId}
```

### HTTP 메서드를 함께 제한하기

```java
@PostMapping("/items")
String create() {
    return "created";
}
```

경로가 같더라도 GET과 POST는 의미가 다르다. 메서드 조건을 지정하지 않은 `@RequestMapping`은 의도보다 넓은 요청을 받을 수 있으므로, 실제 API에서는 `@GetMapping`, `@PostMapping`처럼 목적이 드러나는 애노테이션이 읽기 쉽다.

### 경로 변수

```java
@GetMapping("/members/{memberId}/orders/{orderId}")
String order(
        @PathVariable long memberId,
        @PathVariable long orderId
) {
    return memberId + ":" + orderId;
}
```

경로 자체가 식별자를 포함할 때 `@PathVariable`을 사용한다.

### 추가 매핑 조건

요청 파라미터, 헤더, 요청 본문 형식, 응답 가능 형식도 매핑 조건으로 사용할 수 있다.

```java
@GetMapping(
    value = "/reports",
    params = "format=summary"
)
String summary() {
    return "summary";
}
```

```java
@PostMapping(
    value = "/events",
    consumes = "application/json",
    produces = "application/json"
)
EventResponse create(@RequestBody EventRequest request) {
    return new EventResponse(request.name());
}
```

`consumes`는 서버가 받아들일 요청 본문의 미디어 타입, `produces`는 서버가 만들 응답의 미디어 타입과 관련된다.

조건을 지나치게 많이 나누면 같은 URL의 처리 규칙을 찾기 어려워질 수 있다. API 의미를 HTTP 메서드와 경로로 충분히 표현할 수 있는지 먼저 확인한다.

---

## 3. 리소스 중심의 API 매핑

회원 리소스를 예로 들면 공통 경로를 클래스에 두고 동작별 메서드를 분리할 수 있다.

```java
@RestController
@RequestMapping("/api/members")
class MemberApiController {

    @GetMapping
    String list() {
        return "member list";
    }

    @PostMapping
    String create() {
        return "member created";
    }

    @GetMapping("/{id}")
    String find(@PathVariable long id) {
        return "member=" + id;
    }

    @PatchMapping("/{id}")
    String update(@PathVariable long id) {
        return "member updated=" + id;
    }

    @DeleteMapping("/{id}")
    String delete(@PathVariable long id) {
        return "member deleted=" + id;
    }
}
```

```text
GET    /api/members
POST   /api/members
GET    /api/members/{id}
PATCH  /api/members/{id}
DELETE /api/members/{id}
```

URI에는 `findMember`, `deleteMember` 같은 동사를 반복하기보다 대상을 표현하고, 행동은 HTTP 메서드가 설명하도록 구성했다.

이 예제는 매핑 구조만 보여 준다. 실제 API에는 입력 검증, 상태 코드, 오류 응답, 서비스 계층 호출, 권한 확인이 추가되어야 한다.

---

## 4. 컨트롤러에서 HTTP 정보 받기

애노테이션 기반 컨트롤러의 메서드는 요청 처리에 필요한 여러 값을 파라미터로 받을 수 있다.

```java
@GetMapping("/request-info")
String requestInfo(
        HttpServletRequest request,
        HttpMethod method,
        Locale locale,
        @RequestHeader("Host") String host,
        @CookieValue(
            value = "sessionKey",
            required = false
        ) String sessionKey
) {
    return method + " " + host;
}
```

Spring MVC가 메서드 선언을 보고 요청 객체, HTTP 메서드, 지역 정보, 헤더, 쿠키 등을 준비한다.

모든 헤더를 조회할 때는 하나의 이름에 여러 값이 들어갈 수 있다는 점을 고려해야 한다.

```java
@GetMapping("/all-headers")
String headers(
        @RequestHeader MultiValueMap<String, String> headers
) {
    return headers.toString();
}
```

### 주의할 점

컨트롤러에 `HttpServletRequest`를 직접 전달받는 방식은 세밀한 제어가 가능하지만 서블릿 API 의존성이 커진다. 단순히 특정 헤더나 쿠키 하나가 필요하다면 `@RequestHeader`, `@CookieValue`가 의도를 더 분명하게 보여 준다.

---

## 5. 요청 파라미터와 메시지 본문 구분

클라이언트가 값을 보내는 방식은 크게 다음처럼 나누어 볼 수 있다.

| 전달 방식 | 예시 | 주로 사용하는 기능 |
|---|---|---|
| 쿼리 파라미터 | `/products?keyword=mouse&page=1` | `@RequestParam` |
| HTML Form | `application/x-www-form-urlencoded` | `@RequestParam`, `@ModelAttribute` |
| HTTP 메시지 본문 | JSON, 일반 텍스트 | `@RequestBody`, `HttpEntity` |

GET 쿼리와 기본 HTML Form은 표현 위치는 다르지만 서버에서는 요청 파라미터로 다룰 수 있다.

```java
@GetMapping("/search")
String search(HttpServletRequest request) {
    String keyword = request.getParameter("keyword");
    return keyword;
}
```

이 방법은 서블릿 단계의 동작을 직접 확인하기에는 좋지만, 타입 변환과 필수 여부를 코드에서 반복 처리해야 한다.

JSON은 요청 파라미터가 아니다. JSON 본문을 `request.getParameter()`나 `@ModelAttribute`로 읽으려 하면 기대한 객체 변환이 이루어지지 않는다.

---

## 6. `@RequestParam`으로 단순 값 받기

```java
@GetMapping("/search")
String search(
        @RequestParam String keyword,
        @RequestParam(defaultValue = "0") int page
) {
    return keyword + ":" + page;
}
```

요청 파라미터 이름과 Java 변수 이름이 같으면 애노테이션의 이름 속성을 생략할 수 있다.

```java
@RequestParam("memberName") String name
```

위 코드는 `memberName`이라는 요청 값을 `name` 변수에 넣겠다는 뜻이다.

### 필수값과 기본값

```java
@RequestParam(required = false) String category
```

값이 없을 수 있는 문자열에는 `null`을 받을 수 있다.

기본형 `int`는 `null`을 담을 수 없으므로 선택값이면 `Integer`를 사용하거나 기본값을 지정하는 편이 안전하다.

```java
@RequestParam(defaultValue = "10") int size
```

빈 문자열도 기본값으로 대체될 수 있으므로 사용자가 정말 빈 값을 보낸 경우와 값이 없던 경우를 구분해야 하는 API라면 별도 처리가 필요하다.

### 여러 파라미터를 한 번에 받기

```java
@GetMapping("/parameters")
String parameters(
        @RequestParam Map<String, String> values
) {
    return values.toString();
}
```

임의의 검색 조건을 받을 때 편리하지만, 필수 항목과 타입이 코드에 드러나지 않는다. 입력 구조가 정해져 있다면 명시적인 파라미터나 객체로 묶는 편이 검증과 유지보수에 유리하다.

---

## 7. `@ModelAttribute`로 요청값을 객체에 묶기

여러 파라미터를 각각 받은 뒤 객체에 옮기는 코드는 반복되기 쉽다.

```java
class SearchCondition {

    private String keyword;
    private Integer minPrice;

    public String getKeyword() {
        return keyword;
    }

    public void setKeyword(String keyword) {
        this.keyword = keyword;
    }

    public Integer getMinPrice() {
        return minPrice;
    }

    public void setMinPrice(Integer minPrice) {
        this.minPrice = minPrice;
    }
}
```

```java
@GetMapping("/products")
String products(
        @ModelAttribute SearchCondition condition
) {
    return condition.getKeyword();
}
```

Spring MVC는 객체를 만들고 요청 파라미터 이름에 대응하는 프로퍼티에 값을 바인딩한다.

```text
keyword=spring
→ setKeyword("spring")

minPrice=10000
→ 문자열을 Integer로 변환
→ setMinPrice(10000)
```

복합 객체 파라미터에서는 `@ModelAttribute`가 생략될 수 있지만, 학습 단계나 팀 규칙에서는 입력 출처를 분명히 하기 위해 명시하는 것도 좋다.

### 한계와 주의점

- 필드 이름과 요청 파라미터 이름이 맞아야 한다.
- 숫자나 날짜 변환이 실패하면 바인딩 오류가 발생한다.
- 입력 객체와 도메인 객체를 그대로 공유하면 수정되면 안 되는 필드까지 외부 입력에 노출할 수 있다.
- 실제 애플리케이션에서는 전용 요청 DTO와 검증 규칙을 두는 편이 안전하다.

`@ModelAttribute`는 주로 쿼리 파라미터와 Form 데이터 바인딩에 사용한다. JSON 본문 변환은 `@RequestBody`의 역할이다.

---

## 8. 일반 텍스트 본문 읽기

요청 본문을 가장 낮은 수준에서 읽으면 입력 스트림을 직접 사용할 수 있다.

```java
@PostMapping("/messages/raw")
void raw(
        HttpServletRequest request,
        HttpServletResponse response
) throws IOException {
    String body = StreamUtils.copyToString(
            request.getInputStream(),
            StandardCharsets.UTF_8
    );

    response.getWriter().write(body);
}
```

Spring MVC는 스트림이나 문자 Writer 자체도 메서드 파라미터로 제공할 수 있다.

```java
@PostMapping("/messages/stream")
void stream(
        InputStream input,
        Writer output
) throws IOException {
    String body = StreamUtils.copyToString(
            input,
            StandardCharsets.UTF_8
    );
    output.write(body);
}
```

하지만 매번 인코딩과 스트림 처리를 직접 작성하는 것은 반복이 많다.

### `HttpEntity`

```java
@PostMapping("/messages/entity")
HttpEntity<String> entity(HttpEntity<String> request) {
    String body = request.getBody();
    return new HttpEntity<>("received: " + body);
}
```

`HttpEntity`는 본문과 헤더를 함께 다룰 수 있으며 뷰 렌더링 대신 HTTP 메시지 본문을 사용한다.

요청에 특화된 정보가 더 필요하면 `RequestEntity`, 응답 상태를 직접 정하려면 `ResponseEntity`를 사용할 수 있다.

### `@RequestBody`와 `@ResponseBody`

```java
@ResponseBody
@PostMapping("/messages")
String message(@RequestBody String body) {
    return "received: " + body;
}
```

- `@RequestBody`: 요청 메시지 본문을 메서드 인자로 변환
- `@ResponseBody`: 반환값을 응답 메시지 본문에 기록

이때 뷰 이름을 찾지 않는다.

요청 스트림은 일반적으로 한 번 읽으면 소비된다. 로깅 필터에서 본문을 먼저 읽은 뒤 컨트롤러가 다시 읽으려 하면 문제가 생길 수 있으므로 본문 캐싱이 필요할 수 있다.

---

## 9. JSON 요청을 객체로 변환하기

직접 처리한다면 JSON 문자열을 읽고 `ObjectMapper`로 변환할 수 있다.

```java
@PostMapping("/members/manual")
@ResponseBody
String manual(@RequestBody String json)
        throws JsonProcessingException {
    MemberRequest request =
            objectMapper.readValue(json, MemberRequest.class);

    return request.name();
}
```

Spring MVC에서는 다음처럼 본문을 객체로 바로 받을 수 있다.

```java
record MemberRequest(
        String name,
        int age
) {
}
```

```java
@PostMapping("/members")
@ResponseBody
MemberRequest create(
        @RequestBody MemberRequest request
) {
    return request;
}
```

요청의 `Content-Type`이 JSON이고 적절한 메시지 컨버터가 선택되면 JSON과 객체 사이의 변환을 프레임워크가 수행한다.

### `@RequestBody`를 생략하면 안 되는 이유

복합 타입 파라미터에서 `@RequestBody`를 빼면 요청 본문이 아니라 요청 파라미터 바인딩 대상으로 해석될 수 있다.

```java
// JSON 본문을 받는 의도가 명확하지 않음
MemberRequest request
```

```java
// JSON 본문을 객체로 변환
@RequestBody MemberRequest request
```

입력 위치가 완전히 다르므로 명시적으로 구분해야 한다.

### 객체를 그대로 반환할 때

```java
@ResponseBody
@GetMapping("/members/sample")
MemberResponse sample() {
    return new MemberResponse(1L, "memberA");
}
```

반환 객체도 JSON으로 변환할 수 있다.

도메인 엔티티를 그대로 응답하면 내부 필드나 연관관계가 의도치 않게 노출될 수 있다. API 응답 전용 DTO를 두는 편이 변경 범위와 노출 데이터를 관리하기 쉽다.

---

## 10. 정적 리소스와 뷰 템플릿 응답

서버가 브라우저에 결과를 전달하는 방식은 다음 세 가지로 구분해서 이해했다.

```text
정적 파일
동적으로 렌더링한 View
HTTP 메시지 본문
```

### 정적 리소스

Spring Boot 프로젝트에서는 정적 파일을 클래스패스의 정해진 위치에 둘 수 있다.

```text
src/main/resources/static
```

예를 들어 다음 파일은 별도의 컨트롤러 없이 접근할 수 있다.

```text
src/main/resources/static/assets/help.html
→ /assets/help.html
```

정적 파일은 요청마다 서버 데이터로 내용을 조립하지 않는다. 변경이 드문 파일은 캐시나 CDN을 활용하기 좋다.

### 뷰 템플릿

동적인 HTML이 필요하면 컨트롤러가 모델 데이터를 준비하고 뷰 템플릿이 화면을 만든다.

```java
@Controller
class PageController {

    @GetMapping("/welcome")
    String welcome(Model model) {
        model.addAttribute("name", "memberA");
        return "welcome";
    }
}
```

```html
<p th:text="${name}">name</p>
```

문자열 `"welcome"`은 응답 본문이 아니라 논리적인 뷰 이름으로 해석된다.

컨트롤러에 `@ResponseBody`가 있거나 클래스가 `@RestController`라면 같은 문자열이 메시지 본문으로 처리되므로 용도를 혼동하지 않아야 한다.

---

## 11. HTTP API 응답 만들기

가장 직접적인 방식은 `HttpServletResponse`에 본문을 쓰는 것이다.

```java
@GetMapping("/api/raw")
void rawResponse(HttpServletResponse response)
        throws IOException {
    response.setContentType("text/plain");
    response.getWriter().write("ok");
}
```

세부 제어는 가능하지만 상태 코드, 헤더, 본문 작성 코드가 컨트롤러마다 반복될 수 있다.

### `ResponseEntity`

```java
@GetMapping("/api/members/{id}")
ResponseEntity<MemberResponse> member(
        @PathVariable long id
) {
    MemberResponse body =
            new MemberResponse(id, "memberA");

    return ResponseEntity
            .ok()
            .header("X-Api-Version", "1")
            .body(body);
}
```

응답 상태, 헤더, 본문을 하나의 반환값으로 명확하게 표현할 수 있다.

### `@ResponseStatus`

```java
@ResponseStatus(HttpStatus.CREATED)
@PostMapping("/api/members")
@ResponseBody
MemberResponse createMember() {
    return new MemberResponse(10L, "memberB");
}
```

항상 같은 상태를 반환하는 단순한 경우에는 편리하다. 처리 결과에 따라 상태를 바꿔야 한다면 `ResponseEntity`가 더 유연하다.

### `@RestController`

```java
@RestController
class HealthApiController {

    @GetMapping("/health")
    String health() {
        return "UP";
    }
}
```

`@RestController`는 클래스의 반환값을 기본적으로 응답 본문으로 처리한다. HTML View 컨트롤러와 API 컨트롤러의 역할을 분리하면 반환 문자열의 의미가 더 명확해진다.

---

## 12. HTTP 메시지 컨버터

`@RequestBody`, `@ResponseBody`, `HttpEntity`, `ResponseEntity`를 사용할 때 Spring MVC는 HTTP 메시지 컨버터를 이용한다.

```text
요청 본문
→ 적절한 HttpMessageConverter 선택
→ String 또는 Java 객체로 변환
→ 컨트롤러 호출

컨트롤러 반환값
→ 적절한 HttpMessageConverter 선택
→ 문자열, JSON 등의 본문 생성
→ HTTP 응답
```

대표적인 처리 방향은 다음과 같다.

| Java 타입 | 주로 사용되는 변환 |
|---|---|
| `String` | 문자열 본문 |
| 객체 | JSON 본문 |
| `byte[]` | 바이트 데이터 |

컨버터는 대상 Java 타입과 미디어 타입을 보고 읽거나 쓸 수 있는지 판단한다.

```text
canRead(type, mediaType)
canWrite(type, mediaType)
```

### 요청 변환에서 중요한 값

- 컨트롤러 파라미터 타입
- 요청의 `Content-Type`

### 응답 변환에서 중요한 값

- 컨트롤러 반환 타입
- 요청의 `Accept`
- 컨트롤러의 `produces` 조건
- 서버가 지원하는 미디어 타입

`Content-Type`이 잘못되면 JSON 형태의 문자열을 보냈더라도 JSON 객체 변환이 선택되지 않을 수 있다. 반대로 클라이언트가 서버가 만들 수 없는 형식을 요구하면 적절한 응답을 만들지 못한다.

메시지 컨버터는 뷰 렌더링과 다른 경로다. HTML 템플릿을 선택하는 ViewResolver와 JSON 본문을 만드는 메시지 컨버터를 같은 기능으로 보면 흐름이 헷갈린다.

---

## 13. `RequestMappingHandlerAdapter` 내부 흐름

애노테이션 기반 컨트롤러의 다양한 파라미터와 반환값을 처리하는 중심에는 `RequestMappingHandlerAdapter`가 있다.

```text
DispatcherServlet
→ HandlerMapping이 컨트롤러 메서드 탐색
→ RequestMappingHandlerAdapter 선택
→ ArgumentResolver가 메서드 인자 준비
→ 컨트롤러 메서드 호출
→ ReturnValueHandler가 반환값 처리
→ View 렌더링 또는 메시지 본문 작성
```

### ArgumentResolver

컨트롤러의 각 파라미터를 누가 만들어 줄지 결정한다.

```java
@GetMapping("/orders/{id}")
OrderResponse order(
        @PathVariable long id,
        @RequestHeader("User-Agent") String userAgent,
        Principal principal
) {
    // ...
}
```

겉으로는 평범한 메서드 호출처럼 보이지만, 실제로는 파라미터마다 지원 가능한 ArgumentResolver가 선택되어 값을 준비한다.

개념적인 동작은 다음과 같다.

```text
이 파라미터를 처리할 수 있는가?
→ 가능하면 요청에서 필요한 값 생성
→ 타입 변환과 바인딩 수행
→ 컨트롤러 호출 인자로 전달
```

`@RequestBody`와 `HttpEntity`를 처리하는 리졸버는 내부에서 메시지 컨버터를 사용해 본문을 객체로 바꾼다.

### ReturnValueHandler

컨트롤러가 반환한 값을 어떻게 처리할지 정한다.

```text
String + 일반 @Controller
→ View 이름으로 처리 가능

ModelAndView
→ Model과 View 처리

@ResponseBody 객체
→ 메시지 컨버터로 JSON 작성

ResponseEntity
→ 상태, 헤더, 본문 처리
```

반환 타입과 애노테이션에 따라 서로 다른 ReturnValueHandler가 선택된다.

### 이 구조가 중요한 이유

컨트롤러 메서드에서 사용할 수 있는 파라미터와 반환 형태가 많은 이유는 하나의 거대한 조건문 때문이 아니라, 역할별 처리기가 나뉘어 있기 때문이다.

문제가 생겼을 때 다음 순서로 살펴볼 수 있다.

```text
요청이 메서드에 연결되지 않음
→ RequestMapping 조건 확인

파라미터 값 생성 실패
→ ArgumentResolver, 바인딩, 타입 변환 확인

JSON 변환 실패
→ Content-Type과 메시지 컨버터 확인

반환값이 View로 해석됨
→ @ResponseBody 또는 @RestController 확인

응답 형식 협상 실패
→ Accept, produces, 반환 타입 확인
```

---

## 전체 흐름 정리

```text
1. 요청이 DispatcherServlet에 도착
2. HandlerMapping이 매핑 조건에 맞는 메서드를 찾음
3. HandlerAdapter가 실행 준비
4. ArgumentResolver가 요청값을 메서드 인자로 변환
5. 컨트롤러가 애플리케이션 로직을 호출
6. ReturnValueHandler가 반환값의 처리 방식을 결정
7. ViewResolver 또는 HttpMessageConverter가 최종 응답 생성
```

## 내가 구분해서 기억할 기준

| 질문 | 선택 |
|---|---|
| URL의 단순 값을 받고 싶은가 | `@RequestParam`, `@PathVariable` |
| 쿼리나 Form 값을 객체로 묶고 싶은가 | `@ModelAttribute` |
| JSON이나 텍스트 본문을 읽고 싶은가 | `@RequestBody` |
| 요청 헤더와 본문을 함께 다루고 싶은가 | `HttpEntity`, `RequestEntity` |
| 상태 코드와 헤더까지 직접 응답하고 싶은가 | `ResponseEntity` |
| HTML 화면을 렌더링할 것인가 | `@Controller` + View |
| 객체를 JSON으로 응답할 것인가 | `@ResponseBody` 또는 `@RestController` |

## 핵심 정리

- 요청 매핑은 경로뿐 아니라 HTTP 메서드와 미디어 타입 조건도 고려한다.
- 요청 파라미터와 HTTP 메시지 본문은 서로 다른 입력 경로다.
- `@RequestParam`은 단순 값, `@ModelAttribute`는 파라미터 객체 바인딩에 적합하다.
- JSON 본문은 `@RequestBody`와 메시지 컨버터를 통해 객체로 변환한다.
- View 응답과 메시지 본문 응답은 처리 흐름이 다르다.
- `ResponseEntity`는 상태, 헤더, 본문을 함께 표현한다.
- ArgumentResolver는 컨트롤러 인자를 만들고 ReturnValueHandler는 반환값을 해석한다.
- Spring MVC의 편리함은 여러 처리기가 각 역할을 나누는 구조에서 나온다.
