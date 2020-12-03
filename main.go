package main

import (
	"flag"
	"fmt"
	"log"
	"math/rand"
	"os"
	"storage-throughput-bench/client"
	"sync"
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
	thread     = flag.Int("thread", 1, "number of concurrent thread")
)

func perform(duration time.Duration, threadIdx int, s3 *client.S3, wg *sync.WaitGroup) {
	t := time.NewTicker(duration)
	defer wg.Done()
	defer t.Stop()
	quitC := make(chan bool, 1)
	go func() {
		for {
			select {
			case <-quitC:
				return
			default:
				currentIdx := atomic.AddInt64(keyIdx, 1)
				key := generateKey(currentIdx, threadIdx)
				val := make([]byte, SIZE)
				rand.Read(val)
				fmt.Printf("thread is %v, key is %v\n", threadIdx, key)
				start := time.Now()
				err := s3.Set(key, val)
				if err != nil {
					fmt.Printf("idx %v set err is %v\n", currentIdx, err)
				}
				duration := time.Since(start)
				log.Printf("%v,%v,%v", key, SIZE, duration.Seconds())
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

func generateKey(idx int64, threadIdx int) string {
	year, month, day := time.Now().Date()
	hour, minute, second := time.Now().Clock()
	return fmt.Sprintf("%v%v%v-%v%v%v-%v-%v", year, int(month), day, hour, minute, second, idx, threadIdx)
}

func main() {
	flag.Parse()

	f, err := os.OpenFile(*fileName, os.O_WRONLY|os.O_CREATE|os.O_APPEND, 0644)
	if err != nil {
		log.Fatal(err)
	}
	//set output of logs to f
	log.SetOutput(f)
	defer f.Close()

	log.Printf("key, size, duration\n")
	s3Client := client.NewS3Client(*bucketName)
	var wg sync.WaitGroup
	start := time.Now()
	for i := 0; i < *thread; i++ {
		wg.Add(1)
		go perform(BenchDuration, i, s3Client, &wg)
	}
	wg.Wait()
	duration := time.Since(start)
	log.Printf("Total latency is %v\n", duration.Seconds())
}
