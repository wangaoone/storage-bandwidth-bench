package main

import (
	"flag"
	"fmt"
	"log"
	"math/rand"
	"os"
	"storage-throughput-bench/client"
	"sync/atomic"
	"time"
)

const (
	SIZE          = 1024 * 1024 * 10
	BenchDuration = 60 * time.Second
)

var (
	keyIdx     = flag.Int64("keyIdx", 0, "key start index")
	fileName   = flag.String("o", "tempFile", "output file name")
	bucketName = flag.String("bucket", "bandwidth.ao.test", "bucket name")
)

func perform(duration time.Duration, thread int, s3 *client.S3) {
	t := time.NewTicker(duration)
	defer t.Stop()
	quitC := make(chan bool, 1)
	go func() {
		for {
			select {
			case <-quitC:
				return
			default:
				currentIdx := atomic.AddInt64(keyIdx, 1)
				key := generateKey(currentIdx)
				val := make([]byte, SIZE)
				rand.Read(val)
				start := time.Now()
				err := s3.Set(key, val)
				if err != nil {
					fmt.Printf("idx %v set err is %v\n", currentIdx, err)
				}
				duration := time.Since(start)
				log.Printf("%v,%v,%v", key, SIZE, duration)
			}
		}
	}()
	select {
	case <-t.C:
		log.Println("Timeout, going to return")
		quitC <- true
		return
	}
}

func generateKey(idx int64) string {
	year, month, day := time.Now().Date()
	hour, minute, second := time.Now().Clock()
	return fmt.Sprintf("%v%v%v-%v%v%v-%v", year, int(month), day, hour, minute, second, idx)
}

func main() {
	f, err := os.OpenFile(*fileName, os.O_WRONLY|os.O_CREATE|os.O_APPEND, 0644)
	if err != nil {
		log.Fatal(err)
	}
	//set output of logs to f
	log.SetOutput(f)

	defer f.Close()
	log.Printf("key, size, duration\n")
	s3Client := client.NewS3Client(*bucketName)
	start := time.Now()
	perform(BenchDuration, 1, s3Client)
	duration := time.Since(start)
	log.Printf("Total latency is %v\n", duration)
}
