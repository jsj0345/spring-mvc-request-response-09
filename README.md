# spring-mvc-request-response-09

Spring MVC의 기본 기능을 학습하고 HTTP 요청과 응답 처리 방식을 예제 코드로 정리한 저장소입니다.

로깅, 요청 매핑, HTTP 요청 파라미터, 요청 메시지 처리, View Template, HTTP API 응답, HTTP 메시지 컨버터 등 Spring MVC가 클라이언트의 요청을 처리하고 응답을 생성하는 과정을 학습했습니다.

## 학습 목적

Spring MVC에서 HTTP 요청이 Controller에 매핑되고, 요청 데이터를 다양한 방식으로 전달받아 View 또는 HTTP 메시지 바디로 응답하는 흐름을 이해하기 위해 정리했습니다.

Servlet API를 직접 사용하는 방식부터 Spring MVC가 제공하는 애노테이션과 객체를 활용하는 방식까지 단계적으로 비교하면서, 요청과 응답을 효율적으로 처리하는 방법을 익히는 데 중점을 두었습니다.

## 학습 내용

- Slf4j와 Logback을 활용한 로깅
- 로그 레벨과 올바른 로그 출력 방식
- `@RequestMapping`을 활용한 요청 매핑
- HTTP 메서드별 요청 매핑
- `@PathVariable`을 활용한 경로 변수 처리
- 파라미터, 헤더, Content-Type, Accept 조건 매핑
- REST API 형태의 요청 매핑
- HTTP 요청 헤더와 쿠키 조회
- 쿼리 파라미터와 HTML Form 데이터 처리
- `@RequestParam`을 활용한 요청 파라미터 처리
- `@ModelAttribute`를 활용한 객체 바인딩
- `@RequestBody`와 `HttpEntity`를 활용한 요청 메시지 처리
- JSON 요청 데이터의 객체 변환
- `Model`, `ModelAndView`를 활용한 View 데이터 전달
- `@ResponseBody`, `ResponseEntity`를 활용한 HTTP API 응답
- HTTP 메시지 컨버터의 동작 방식
- 요청 매핑 핸들러 어댑터의 구조

## 디렉터리 구조

    springmvc
    ├── gradle
    ├── src
    │   ├── main
    │   │   ├── docs
    │   │   │   └── springmvc_core_features.md
    │   │   ├── java
    │   │   │   └── hello
    │   │   │       └── springmvc
    │   │   │           ├── basic
    │   │   │           │   ├── request
    │   │   │           │   ├── requestmapping
    │   │   │           │   └── response
    │   │   │           └── SpringmvcApplication.java
    │   │   ├── resources
    │   │   │   ├── static
    │   │   │   ├── templates
    │   │   │   └── application.properties
    │   │   └── sql
    │   └── test
    │       └── java
    │           └── hello
    │               └── springmvc
    ├── build.gradle
    ├── gradlew
    ├── gradlew.bat
    └── settings.gradle

## 학습 포인트

- Slf4j와 Logback을 사용해 로그 레벨별로 정보를 출력하고, 문자열 연산을 줄이는 올바른 로그 사용 방식을 학습했습니다.
- `@RequestMapping`, `@GetMapping`, `@PostMapping` 등을 사용해 URL과 HTTP 메서드를 Controller 메서드에 연결하는 방식을 익혔습니다.
- `@PathVariable`, `@RequestParam`, `@ModelAttribute`를 사용해 URL 경로와 요청 파라미터를 메서드 인자 또는 객체로 전달받는 흐름을 확인했습니다.
- Servlet API, `HttpEntity`, `@RequestBody`를 비교하며 HTTP 메시지 바디의 문자열과 JSON 데이터를 처리하는 방법을 학습했습니다.
- `Model`, `ModelAndView`를  사용해 Controller에서 View로 데이터를 전달하고 화면을 렌더링하는 과정을 이해했습니다.
- `HttpServletResponse`, `ResponseEntity`, `@ResponseBody`를 비교하며 문자열과 JSON 데이터를 HTTP 메시지 바디에 직접 반환하는 방식을 익혔습니다.
- HTTP 메시지 컨버터가 요청 데이터를 객체로 변환하고 반환 객체를 JSON 응답으로 변환하는 동작 원리를 학습했습니다.

## 실행 환경

- Java 17
- Spring Boot 3.5.6
- Spring MVC
- Gradle
- Lombok
- Slf4j
- Logback
- IntelliJ IDEA
- HTML
