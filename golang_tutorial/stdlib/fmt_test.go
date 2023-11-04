package main

import (
	"fmt"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestScanDifferenceFromC(t *testing.T) {
	s := "A C B \nA"

	var a, b, c string

	// newline cannot be replaced by a space
	_, e := fmt.Sscanf(s, "%s %s %s  A", &a, &b, &c)
	assert.ErrorContains(t, e, "not match format")

	_, e = fmt.Sscanf(s, "%s %s %s \nA", &a, &b, &c)
	assert.Nil(t, e)
}
