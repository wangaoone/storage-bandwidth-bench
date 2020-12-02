package client

import (
	"bytes"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3"
	"github.com/aws/aws-sdk-go/service/s3/s3manager"
)

type S3 struct {
	bucket     string
	uploader   *s3manager.Uploader
	downloader *s3manager.Downloader
}

func NewS3Client(bucket string) *S3 {
	awsSession := session.Must(session.NewSessionWithOptions(session.Options{
		SharedConfigState: session.SharedConfigEnable,
		Config:            aws.Config{Region: aws.String("us-east-1")},
	}))

	return &S3{
		bucket:     bucket,
		uploader:   s3manager.NewUploader(awsSession),
		downloader: s3manager.NewDownloader(awsSession),
	}
}

func (c *S3) Get(key string) ([]byte, error) {
	buff := new(aws.WriteAtBuffer)
	_, err := c.downloader.Download(buff, &s3.GetObjectInput{
		Bucket: aws.String(c.bucket),
		Key:    aws.String(key),
	})
	if err != nil {
		return nil, err
	} else {
		return buff.Bytes(), nil
	}
}

func (c *S3) Set(key string, val []byte) error {
	// Upload the file to S3.
	_, err := c.uploader.Upload(&s3manager.UploadInput{
		Bucket: aws.String(c.bucket),
		Key:    aws.String(key),
		Body:   bytes.NewReader(val),
	})
	//fmt.Println("set output is", setOutput.UploadID)

	return err
}
