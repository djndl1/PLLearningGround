package time_test

import (
	"fmt"
	"time"
	"testing"
	"github.com/stretchr/testify/assert"
)

func TestLocalTimeNow(t *testing.T) {
	now := time.Now()

	fmt.Println(now);
}

func TestUTCTimeNow(t *testing.T) {
	utcNow := time.Now().UTC()

	fmt.Println(utcNow)
	fmt.Println(utcNow.Format(time.RFC3339Nano))
}

func TestUnixTime(t *testing.T) {
	randomTime := time.Date(2023, 7, 1, 1, 1, 1, 0, time.Local)

	secondsSinceEpoch := randomTime.Unix()
	assert.Equal(t, int64(1688144461), secondsSinceEpoch)
	assert.Equal(t, int64(1688144461_000), randomTime.UnixMilli())
	assert.Equal(t, int64(1688144461_000000), randomTime.UnixMicro())
	assert.Equal(t, int64(1688144461 * time.Second), randomTime.UnixNano())
}

func TestTimeZone(t *testing.T) {
	now := time.Now()
	name, offset := now.Zone()

	assert.Equal(t, "CST", name)
	assert.Equal(t, 8 * 3600, offset)
}

func TestAsSeconds(t *testing.T) {
 	now := time.Now()

	fmt.Println(now.Truncate(time.Second)) // duration constants are available
}

func TestLoadLocation(t *testing.T) {
	shanghai, _ := time.LoadLocation("Asia/Shanghai")

	shanghaiTime := time.Date(2023, time.January, 1, 0, 0, 0, 0, shanghai)
	localTime := time.Date(2023, time.January, 1, 0, 0, 0, 0, time.Local)

	assert.True(t, shanghaiTime.Equal(localTime))
}

func TestTimezoneConversion(t *testing.T) {
	shanghai, _ := time.LoadLocation("Asia/Shanghai")
	shanghaiTime := time.Date(2023, time.January, 1, 0, 0, 0, 0, shanghai)

	utcTime := shanghaiTime.In(time.UTC)

	assert.True(t, utcTime.Equal(time.Date(2022, time.December, 31, 16, 0, 0, 0, time.UTC)))
}
