rootlist=(
  ubuntu@ec2-54-196-7-52.compute-1.amazonaws.com
  ubuntu@ec2-54-196-82-80.compute-1.amazonaws.com
  ubuntu@ec2-3-85-94-199.compute-1.amazonaws.com
  ubuntu@ec2-54-175-151-221.compute-1.amazonaws.com
  ubuntu@ec2-54-81-224-121.compute-1.amazonaws.com
  ubuntu@ec2-3-90-148-79.compute-1.amazonaws.com
  ubuntu@ec2-54-226-187-117.compute-1.amazonaws.com
  ubuntu@ec2-3-89-182-124.compute-1.amazonaws.com
  ubuntu@ec2-54-198-161-205.compute-1.amazonaws.com
  ubuntu@ec2-54-91-40-249.compute-1.amazonaws.com
)

GOOS=linux go build
SSHKEY=

for i in "${rootlist[@]}"; do
  echo "$i"
  scp ${GOPATH}/src/storage-throughput-bench/storage-throughput-bench "$i":~/.
  echo "Upload finished"
done

go clean
