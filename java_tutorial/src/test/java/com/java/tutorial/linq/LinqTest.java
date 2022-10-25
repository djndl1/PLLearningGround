package com.java.tutorial.linq;

import java.math.BigDecimal;
import java.util.*;
import java.util.stream.Stream;

import com.google.common.collect.Comparators;
import com.google.common.math.Stats;

import org.apache.commons.lang3.math.NumberUtils;
import org.assertj.core.data.Offset;
import org.junit.jupiter.api.Test;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import static org.assertj.core.api.Assertions.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
class Pet {
    private String name;
    private int age;
}

public class LinqTest {
    private final static List<String> FRUITS = Arrays.asList(
        "apple", "mango", "orange", "passionfruit", "grape"
    );

    private final static List<Pet> PETS = Arrays.asList(
        new Pet("Barley", 10),
        new Pet("Boots", 4),
        new Pet("Whiskers", 6)
    );

    @Test
    void testAggregate_Reduce() {
        String longestName = FRUITS.stream().reduce("banana", (result, next) ->
            result.length() < next.length() ? next : result)
            .toUpperCase();

        assertThat(longestName).isEqualTo("PASSIONFRUIT");

        String nullName = (new ArrayList<String>()).stream().reduce((result, next) ->
            result.length() < next.length() ? next : result).orElse(null);

        assertThat(nullName).isNull();
    }

    @Test
    void testMaxLength_Reduce() {
        int maxLength = FRUITS.stream().reduce(0, (maxLen, next) ->
            next.length() > maxLen ? next.length() : maxLen,
            Comparators::max);
            
        assertThat(maxLength).isEqualTo(12);

        maxLength = FRUITS.stream().map(f -> f.length()).max((a, b) -> a > b ? 1 : a == b ? 0 : -1).get();
        assertThat(maxLength).isEqualTo(12);
    }

    @Test
    void testSumLength_Reduce() {
        int sumLength = FRUITS.stream().reduce(0, (sum, next) -> 
            sum + next.length(), (a, b) -> a + b);

        assertThat(sumLength).isEqualTo(33);
    }

    @Test
    void testSumLength_SumCollector() {
        int sumLength = FRUITS.stream().mapToInt(i -> i.length()).sum();
        assertThat(sumLength).isEqualTo(33);
    }

    @Test
    void testSumLength_GuavaStats() {
        Stats lengthStat = Stats.of(FRUITS.stream().mapToInt(f -> f.length()));

        double sum = lengthStat.sum();

        assertThat(sum).isEqualTo(33.0, offset(0.1));
    }

    @Test
    void testAllAny_Stream() {
        boolean b = PETS.stream().allMatch(i -> i.getName().startsWith("B"));

        assertThat(b).isFalse();

        boolean b2 = PETS.stream().anyMatch(i -> i.getName().startsWith("B"));

        assertThat(b2).isTrue();
    }

    @Test
    void testCountIf_Stream() {
        int hasBCount = PETS.stream().reduce(0, (cnt, p) -> 
            cnt + (p.getName().startsWith("B") ? 1 : 0), (a, b) -> a + b);

        assertThat(hasBCount).isEqualTo(2);
    }

    @Test
    void testAppend_Stream() {
        var appended = Stream.concat(PETS.stream(), Stream.of(new Pet("Test", 11)));

        assertThat(appended).hasSize(4);
    }
}
