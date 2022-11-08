package main

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestParimeter(t *testing.T) {
	rec := Rectangle{10.0, 10.0}
	got := rec.Perimeter()
	want := 40.0

	assert := assert.New(t)

	assert.Equal(got, want)
}

func TestArea(t *testing.T) {
	rec := Rectangle{10.0, 10.0}
	got := rec.Area()
	want := 100.0

	assert.Equal(t, want, got)
}
