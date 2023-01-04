package main

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestSearch(t *testing.T) {
	dictionary := Dictionary{"test": "this is just a test"}

	got, _ := dictionary.Search("test")

	assert.Equal(t, "this is just a test", got)

	t.Run("unknown word", func(t *testing.T) {
		_, err := dictionary.Search("unknown")

		assert.Equal(t, ErrorKeyNotFound, err)
	})
}

func TestAdd(t *testing.T) {
	t.Run("known", func(t *testing.T) {
		dict := Dictionary{}
		dict.Add("test", "this is just a test")

		got, _ := dict.Search("test")

		assert.Equal(t, "this is just a test", got)
	})

	t.Run("unknown", func(t *testing.T) {
		dict := Dictionary{}
		err := dict.Add("test", "this is just a test")
		assert.Nil(t, err)

		err2 := dict.Add("test", "this")
		assert.Equal(t, ErrorKeyExisted, err2)
	})
}

func assertDefinition(t testing.TB, dictionary Dictionary, word, definition string) {
	t.Helper()

	got, err := dictionary.Search(word)
	if err != nil {
		t.Fatal("should find added word:", err)
	}

	if definition != got {
		t.Errorf("got %q want %q", got, definition)
	}
}

func TestUpdate(t *testing.T) {
	t.Run("existing word", func(t *testing.T) {
		word := "test"
		definition := "this is just a test"
		dictionary := Dictionary{word: definition}
		newDefinition := "new definition"

		err := dictionary.Update(word, newDefinition)

		assert.Nil(t, err)
		assertDefinition(t, dictionary, word, newDefinition)
	})

	t.Run("new word", func(t *testing.T) {
		word := "test"
		definition := "this is just a test"
		dictionary := Dictionary{}

		err := dictionary.Update(word, definition)

		assert.Equal(t, ErrorKeyNotFound, err)
	})
}

func TestDelete(t *testing.T) {
	word := "test"
	dictionary := Dictionary{word: "test definition"}

	dictionary.Delete(word)

	_, err := dictionary.Search(word)
	assert.Equal(t, ErrorKeyNotFound, err)
}
