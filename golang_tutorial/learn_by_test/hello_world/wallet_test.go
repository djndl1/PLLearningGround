package main

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestWallet(t *testing.T) {
	t.Run("deposit", func(t *testing.T) {
		wallet := Wallet{}

		wallet.Deposit(Bitcoin(10))

		got := wallet.Balance()
		want := Bitcoin(10)

		assert := assert.New(t)
		assert.Equal(want, got)
	})

	t.Run("withdraw", func(t *testing.T) {
		wallet := Wallet{balance: Bitcoin(20)}

		err := wallet.Withdraw(Bitcoin(10))

		want := Bitcoin(10)
		assert := assert.New(t)
		assert.Equal(want, wallet.Balance())
		assert.Nil(err)
	})

	t.Run("insufficient funds", func(t *testing.T) {
		wallet := Wallet{balance: Bitcoin(10)}

		err := wallet.Withdraw(Bitcoin(20))

		want := Bitcoin(10)
		assert := assert.New(t)
		assert.Equal(ErrInsufficientFunds, err)
		assert.Equal(want, wallet.Balance())
	})
}
