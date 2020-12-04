rootlist=(
  ubuntu@ec2-3-90-160-145.compute-1.amazonaws.com
  ubuntu@ec2-54-242-108-107.compute-1.amazonaws.com
)

GOOS=linux go build

for i in "${rootlist[@]}"; do
  echo $i
  scp /Users/ao/go/src/storage-throughput-bench/storage-throughput-bench $i:~/.
  echo "Upload finished"
done
