package com.java.tutorial;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.MapperFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jdk8.Jdk8Module;
import com.fasterxml.jackson.datatype.jsr310.JSR310Module;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

public class TestEnvironment {
    private static ObjectMapper jsonSerializer = null;

    public static ObjectMapper jsonSerializer() {
        if (jsonSerializer == null) {
            jsonSerializer = new ObjectMapper();
            jsonSerializer.registerModules(
                new Jdk8Module(),
                new JavaTimeModule()
            );

            jsonSerializer.disable(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES);
            jsonSerializer.disable(MapperFeature.DEFAULT_VIEW_INCLUSION);
            jsonSerializer.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);

            jsonSerializer.enable(SerializationFeature.INDENT_OUTPUT);
        }

        return jsonSerializer;
    }

}
