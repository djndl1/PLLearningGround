package main

import "errors"

type Dictionary map[string]string

var (
	ErrorKeyNotFound = errors.New("key not found for this dictionary")
	ErrorKeyExisted  = errors.New("key already existed for this dictionary")
)

func (d Dictionary) Search(word string) (string, error) {
	definition, ok := d[word]
	if !ok {
		return "", ErrorKeyNotFound
	}

	return definition, nil
}

func (d Dictionary) Add(word, definition string) error {

	_, err := d.Search((word))
	switch err {
	case ErrorKeyNotFound:
		d[word] = definition
	case nil:
		return ErrorKeyExisted
	default:
		return err
	}

	return nil
}

func (d Dictionary) Update(word, definition string) error {
	_, err := d.Search((word))
	switch err {
	case ErrorKeyNotFound:
		return ErrorKeyNotFound
	case nil:
		d[word] = definition
	default:
		return err
	}

	return nil
}

func (d Dictionary) Delete(word string) error {
	_, err := d.Search((word))
	switch err {
	case ErrorKeyNotFound:
		return ErrorKeyNotFound
	case nil:
		delete(d, word)
	default:
		return err
	}

	return nil
}
