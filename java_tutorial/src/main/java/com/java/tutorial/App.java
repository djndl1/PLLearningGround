package com.java.tutorial;

/**
 * Hello world!
 */
public final class App {
    private App() {
    }

    /**
     * Says hello to the world.
     * @param args The arguments of the program.
     */
    public static void main(String[] args) {
        System.out.println("Output arguments: ");
        for (String arg : args) {
            System.out.println(arg);
        }
    }
}
