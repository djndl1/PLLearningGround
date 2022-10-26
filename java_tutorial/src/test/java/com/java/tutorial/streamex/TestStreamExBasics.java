package com.java.tutorial.streamex;

import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.stream.IntStream;
import java.util.stream.Stream;

import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.java.tutorial.TestEnvironment;
import com.java.tutorial.streamex.User.Role;

import net.datafaker.Faker;
import one.util.streamex.EntryStream;
import one.util.streamex.StreamEx;

public class TestStreamExBasics {
    Stream<User> getUsers() {
        Faker faker = new Faker();

        return IntStream.range(1, 101).boxed().map(i -> {
            var u = new User();

            u.setId(faker.random().nextInt());
            u.setName(faker.name().fullName());
            u.setRole(new Role(faker.random().nextInt(1, 5)));

            return u;
        });
    }

    @Test
    void testGetUserNames() throws JsonProcessingException {
        List<String> names = StreamEx.of(getUsers())
                .map(User::getName)
                .toList();

        assertThat(names).hasSize(100);
        System.out.println(
                TestEnvironment.jsonSerializer().writeValueAsString(names));
    }

    @Test
    void testGroupUsersByRole() throws JsonProcessingException {
        Map<Role, List<User>> role2Users = StreamEx.of(getUsers())
                .groupingBy(User::getRole);

        assertThat(role2Users.values().stream().flatMap(g -> g.stream())).hasSize(100);
    }

    @Test
    void testMapValues() throws JsonProcessingException {
        Map<Role, List<User>> role2Users = StreamEx.of(getUsers())
                .groupingBy(User::getRole);

        Map<Role, List<String>> role2Names = EntryStream.of(role2Users)
                .mapValues(users -> StreamEx.of(users).map(User::getName).toList())
                .toMap();

        assertThat(role2Names.values().stream().flatMap(g -> g.stream())).hasSize(100);
    }

    @Test
    void testOfType() throws JsonProcessingException {
        List roleAndUsers = Arrays.asList(new User(), new Role(1));

        List<Role> roles = StreamEx.of(roleAndUsers)
                .select(Role.class)
                .toList();

        assertThat(roles).allSatisfy(r -> assertThat(r).isInstanceOf(Role.class));
    }

    @Test
    void testInversionOfMap() throws JsonProcessingException {
        Map<Role, List<User>> role2Users = StreamEx.of(getUsers())
                .groupingBy(User::getRole);

        Map<User, List<Role>> users2roles = EntryStream.of(role2Users)
                .flatMapValues(List::stream)
                .invert()
                .grouping();

        System.out.println(TestEnvironment.jsonSerializer().writeValueAsString(users2roles));
    }
}
