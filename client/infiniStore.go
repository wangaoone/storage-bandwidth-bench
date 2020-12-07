package client

import (
	"fmt"
	"strings"

	"github.com/mason-leap-lab/infinicache/client"
)

type InfiniStore struct {
	client *client.PooledClient
}

func NewInfiniStoreClient(addrs interface{}, concurrency int) *InfiniStore {
	var all []string
	switch a := addrs.(type) {
	case []string:
		all = a
	default:
		all = strings.Split(fmt.Sprintf("%v", a), ",")
	}

	cli := client.NewPooledClient(all, func(cli *client.PooledClient) {
		cli.Concurrency = concurrency
	})
	return &InfiniStore{client: cli}
}

func (c *InfiniStore) Get(key string) ([]byte, error) {
	reader, err := c.client.Get(key)
	if err != nil {
		return nil, err
	}
	defer reader.Close()

	return reader.ReadAll()
}

func (c *InfiniStore) Set(key string, val []byte) error {
	return c.client.Set(key, val)
}

func (c *InfiniStore) Close() {
	c.client.Close()
}
