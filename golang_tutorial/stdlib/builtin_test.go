package test_learn

import (
	"math"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestComplexType(t *testing.T) {
	c := complex(1.0, 2.0)

	assert.InDelta(t, 1.0, real(c), math.SmallestNonzeroFloat64)
	assert.InDelta(t, 2.0, imag(c), math.SmallestNonzeroFloat64)
}

func TestSlices(t *testing.T) {
	var slis []string
	slis = append(slis, "a", "b")

	assert.Equal(t, 2, len(slis))
}

func TestPanicRecover(t *testing.T) {
	panicker := func() {
		panic("Panicking")
	}
	defer func() {
		r := recover()
		assert.Equal(t, "Panicking", r)
	}()

	panicker()
}
