package main

func Repeat(s string, times int) (repeated string) {
	for i := 0; i < times; i++ {
		repeated += s
	}
	return
}
