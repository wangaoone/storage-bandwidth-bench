package client

import (
	"errors"
	"github.com/mason-leap-lab/infinicache/client"
)

type InfiniStore struct {
	client client.Client
}

func (c *InfiniStore) Get(key string) ([]byte, error) {
	// place holder
	return nil, nil
}

func (c *InfiniStore) Set(key string, val []byte) error {
	_, ok := c.client.EcSet(key, val)
	if ok == false {
		return errors.New("InfiniStore SET failed")
	}
	return nil
}
