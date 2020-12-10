package client

import (
	"os"
	"path"
)

type fsx struct {
	Path string
}

func NewFsxClient(path string) *fsx {
	return &fsx{Path: path}
}

func (c *fsx) Get(key string) ([]byte, error) {
	//var file *os.File
	//if file, err := os.OpenFile(path.Join(c.Path, key), os.O_RDONLY, 0); err != nil {
	//	return nil, err
	//}
	//defer file.Close()
	//
	//var data []byte
	//if data, err = ioutil.ReadAll(file); err != nil {
	//	return
	//}
	//
	//return NewByteReader(data), nil
	return nil, nil
}

func (c *fsx) Set(key string, val []byte) error {
	var file *os.File
	file, err := os.OpenFile(path.Join(c.Path, key), os.O_CREATE|os.O_TRUNC|os.O_WRONLY, 0644)
	if err != nil {
		return err
	}
	defer file.Close()

	_, err = file.Write(val)
	return err
}

func (c *fsx) Close() {
}
