package com.java.tutorial.webflux;

import java.io.IOException;
import java.util.List;

import org.junit.jupiter.api.Test;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.MediaType;
import org.springframework.web.reactive.function.client.WebClient;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.java.tutorial.TestEnvironment;

import lombok.Data;

import static org.assertj.core.api.Assertions.assertThat;

public class WebClientTest {
    private final static String MY_TEST_TOKEN = "406cf2bcb3cd50df554a03b21cb10ce868ef46525acca1120f0eaf976b958d8e";

    @Data
    public static class Student
    {
        @JsonProperty("id")
        private long id;

        @JsonProperty("name")
        private String name;

        @JsonProperty("email")
        private String email;

        @JsonProperty("gender")
        private String gender;

        @JsonProperty("status")
        private String active;
    }

    @Test
    void testSimpleGet() throws IOException {
        WebClient client = WebClient.builder()
                                    .baseUrl("https://gorest.co.in")
                                    .build();

        List<Student> student = client.get().uri(urlBuilder -> urlBuilder.path("/public/v2/users")
                                                .build())
                    .accept(MediaType.APPLICATION_JSON)
                    .retrieve()
                    .bodyToMono(new ParameterizedTypeReference<List<Student>>() {})
                    .block();

        System.out.println(
            TestEnvironment.jsonSerializer().writeValueAsString(student)
        );
    }
}
