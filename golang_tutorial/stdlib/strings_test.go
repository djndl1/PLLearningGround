package test_learn

import (
	"fmt"
	"io"
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestCloneToSaveMemory(t *testing.T) {
	largeString := "ojipe43hrt f9pq3hy8jpepwfjce0wfasJIFcwfjiojiefhw[aji]"
	sliced := largeString[0:5]
	partOfString := strings.Clone(sliced)

	assert.NotSame(t, partOfString, sliced)
}

func TestJoinSplit(t *testing.T) {
	words := []string{ "a", "b", "c"}

	joined := strings.Join(words, ",")

	assert.Equal(t, "a,b,c", joined)

	splitApart := strings.Split(joined, ",")

	assert.Equal(t, []string{ "a", "b", "c"}, splitApart)
}

func TestStringBuilder(t *testing.T) {
	var b strings.Builder
	b.WriteString("SELECT")
	b.WriteString("       * ")
	b.WriteString("FROM TEST_TABLE")

	assert.Equal(t, "SELECT       * FROM TEST_TABLE", b.String())
}

func TestStringAsFileStream(t *testing.T) {
	var r strings.Reader = *strings.NewReader("1.23 2123\t43")


	var c int = 0
	for b, e := r.ReadByte(); e != io.EOF; b, e = r.ReadByte() {
		fmt.Print(b, " ")
		c++
	}
	fmt.Println()

	r.Seek(0, io.SeekStart);

	buf := make([]byte, c)
	r.Read(buf)

	fmt.Println(buf);

}
