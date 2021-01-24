package hello

import (
	"fmt"

	"github.com/google/uuid"
)

func main() {
	printSomething()
}

func printSomething() {
	uuidObj, _ := uuid.NewUUID()
	id := uuidObj.ID()
	fmt.Println("======")
	fmt.Println("---")
	fmt.Println(fmt.Sprintf("aaa: %+v", id))
}
