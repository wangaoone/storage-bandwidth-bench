package main

import (
	"flag"
	"fmt"
	"github.com/google/uuid"
	"log"
	"math/rand"
	"os"
	"storage-throughput-bench/client"
	"sync"
	"sync/atomic"
	"time"
)

type Client interface {
	Get(string) ([]byte, error)
	Set(string, []byte) error
}

var (
	fileName      = flag.String("o", "tempFile", "output file name")
	bucketName    = flag.String("bucket", "bandwidth.ao.test", "bucket name")
	thread        = flag.Int("thread", 1, "number of concurrent thread")
	size          = flag.Int("size", 10485760, "object size")
	benchDuration = flag.Int("duration", 60, "duration in second")
	storage       = flag.String("storage", "foo", "storage type [s3, redis]")
	redisAddr     = flag.String("endpoint", "foo", "redis endpoint")

	count int64
)

func perform(duration time.Duration, threadIdx int, client Client, val []byte, wg *sync.WaitGroup) {
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
				key := uuid.New().String()
				start := time.Now()
				err := client.Set(key, val)
				if err != nil {
					fmt.Printf("key %vset err is %v\n", key, err)
				}
				duration := time.Since(start)
				atomic.AddInt64(&count, 1)
				fmt.Printf("Set finished, thread is %v, key is %v\n", threadIdx, key)
				log.Printf("%v,%v,%v", key, len(val), duration.Seconds())
			}
		}
	}()
	select {
	case <-t.C:
		fmt.Println("Timeout, going to return")
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

	var wg sync.WaitGroup
	var c Client
	benchDura := time.Duration(*benchDuration) * time.Second
	f, err := os.OpenFile(*fileName, os.O_WRONLY|os.O_CREATE|os.O_APPEND, 0644)
	if err != nil {
		log.Fatal(err)
	}
	//set output of logs to file
	log.SetOutput(f)
	defer f.Close()

	if *storage == "s3" {
		c = client.NewS3Client(*bucketName)
	} else if *storage == "redis" {
		c = client.NewRedisClient(*redisAddr)
	}

	// generate load
	val := make([]byte, *size)
	rand.Read(val)

	log.Printf("key, size, duration\n")
	start := time.Now()
	for i := 0; i < *thread; i++ {
		wg.Add(1)
		go perform(benchDura, i, c, val, &wg)
	}
	wg.Wait()
	duration := time.Since(start)
	fmt.Printf("Total latency is %v\n", duration.Seconds())
	log.Println("Total obj count ", atomic.LoadInt64(&count))
}
