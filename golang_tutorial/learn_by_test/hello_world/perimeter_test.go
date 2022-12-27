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

	areaTests := []struct {
		shape Shape
		want  float64
	}{
		{Rectangle{12, 6}, 72.0},
		{Circle{10}, 314.1592653589793},
	}

	for _, tt := range areaTests {
		got := tt.shape.Area()
		assert := assert.New(t)

		assert.InDelta(tt.want, got, 0.0000001, "%#v got %g want %g", tt.shape, got, tt.want)
	}
}
