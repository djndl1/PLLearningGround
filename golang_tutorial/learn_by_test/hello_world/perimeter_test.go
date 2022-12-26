package main

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestPerimeter(t *testing.T) {
	t.Run("rectangle perimeter", func(t *testing.T) {
		rec := Rectangle{10.0, 10.0}
		got := rec.Perimeter()
		want := 40.0

		assert := assert.New(t)

		assert.Equal(got, want)
	})

	t.Run("circle perimeter", func(t *testing.T) {
		circle := Circle{10}
		got := circle.Perimeter()
		want := 125.66370614 / 2

		assert := assert.New(t)
		assert.InDelta(want, got, 0.00001)
	})
}

func TestArea(t *testing.T) {
	checkArea := func(t testing.TB, shape Shape, want float64) {
		t.Helper()

		got := shape.Area()
		assert := assert.New(t)

		assert.InDelta(want, got, 0.0000001)
	}

	t.Run("rectangle area", func(t *testing.T) {
		rec := Rectangle{10.0, 10.0}
		want := 100.0

		checkArea(t, rec, want)
	})

	t.Run("circle area", func(t *testing.T) {
		circ := Circle{10}
		want := 314.1592653589793
		checkArea(t, circ, want)
	})
}
