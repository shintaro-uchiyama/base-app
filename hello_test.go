package main

import "testing"

func TestPrintSomething(t *testing.T) {
	t.Run("test", func(t *testing.T) {
		printSomething()
	})

}
