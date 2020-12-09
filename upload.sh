rootlist=(
  ubuntu@172.31.47.143
  ubuntu@172.31.34.110
  ubuntu@172.31.43.62
  ubuntu@172.31.43.61
  ubuntu@172.31.41.185
  ubuntu@172.31.39.200
  ubuntu@172.31.45.70
  ubuntu@172.31.41.166
  ubuntu@172.31.35.84
  ubuntu@172.31.46.111
)

GO111MODULE=off GOOS=linux go build
SSHKEY=~/.ssh/ops.pem

SEQ=0
for i in "${rootlist[@]}"; do
  echo "$i"
  scp -i $SSHKEY ${GOPATH}/src/github.com/wangaoone/storage-bandwidth-bench/storage-bandwidth-bench "$i":~/.
  scp -i $SSHKEY ${GOPATH}/src/github.com/wangaoone/storage-bandwidth-bench/init.sh "$i":~/.
  scp -i $SSHKEY ${GOPATH}/src/github.com/wangaoone/storage-bandwidth-bench/proxy.sh "$i":~/.
  ssh -i $SSHKEY $i ./init.sh $SEQ
  echo "Upload finished"
  ((SEQ=SEQ+1))
done

go clean
