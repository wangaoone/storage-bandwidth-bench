rootlist=(
  ubuntu@ec2-18-234-213-195.compute-1.amazonaws.com
  ubuntu@ec2-18-207-176-171.compute-1.amazonaws.com
  ubuntu@ec2-52-5-123-60.compute-1.amazonaws.com
  ubuntu@ec2-35-175-230-27.compute-1.amazonaws.com
  ubuntu@ec2-54-210-121-80.compute-1.amazonaws.com
  ubuntu@ec2-54-198-5-78.compute-1.amazonaws.com
  ubuntu@ec2-54-81-195-147.compute-1.amazonaws.com
  ubuntu@ec2-34-226-220-6.compute-1.amazonaws.com
  ubuntu@ec2-23-20-210-76.compute-1.amazonaws.com
  ubuntu@ec2-54-88-197-63.compute-1.amazonaws.com
)

GOOS=linux go build
SSHKEY=

for i in "${rootlist[@]}"; do
  echo "$i"
  scp -i $SSHKEY ${GOPATH}/src/storage-throughput-bench/storage-throughput-bench "$i":~/.
  echo "Upload finished"
done

go clean
