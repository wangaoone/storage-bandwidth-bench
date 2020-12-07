package client

import (
	"github.com/go-redis/redis/v7"
)

type Redis struct {
	client *redis.Client
}

func NewRedisClient(addr string) *Redis {
	return &Redis{
		client: redis.NewClient(&redis.Options{
			Addr: addr,
		}),
	}
}

func (c *Redis) Get(key string) ([]byte, error) {
	val, err := c.client.Get(key).Bytes()
	if err != nil {
		return nil, err
	}
	return val, nil
}

func (c *Redis) Set(key string, val []byte) error {
	return c.client.Set(key, val, 0).Err()
}

func (c *Redis) Close() {
	c.client.Close()
}
