package com.java.tutorial.streamex;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.Getter;

@Data
public class User {
    @AllArgsConstructor
    @EqualsAndHashCode
    public static class Role {
        @Getter
        private int type;
    }
    private int id;

    private String name;

    private Role role;
}
