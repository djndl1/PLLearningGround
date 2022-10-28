package com.java.tutorial;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.MapperFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.databind.json.JsonMapper;
import com.fasterxml.jackson.datatype.jdk8.Jdk8Module;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

public class TestEnvironment {
    private static ObjectMapper jsonSerializer = null;

    public static ObjectMapper jsonSerializer() {
        if (jsonSerializer == null) {
            jsonSerializer = JsonMapper.builder().disable(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES)
                                .disable(MapperFeature.DEFAULT_VIEW_INCLUSION)
                                .disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS)
                                .enable(SerializationFeature.INDENT_OUTPUT)
                                .addModules(new Jdk8Module(), new JavaTimeModule())
                                .build();
        }

        return jsonSerializer;
    }

}
