rootlist=(
  ubuntu@172.31.37.190
  ubuntu@172.31.37.31
  ubuntu@172.31.32.250
  ubuntu@172.31.40.76
  ubuntu@172.31.34.233
  ubuntu@172.31.41.25
  ubuntu@172.31.36.70
  ubuntu@172.31.41.231
  ubuntu@172.31.37.224
  ubuntu@172.31.47.228
)

GO111MODULE=off GOOS=linux go build
SSHKEY=~/.ssh/ops.pem

SEQ=0
for i in "${rootlist[@]}"; do
  echo "$i"
  scp -i $SSHKEY ${GOPATH}/src/github.com/wangaoone/storage-bandwidth-bench/storage-bandwidth-bench "$i":~/.
  scp -i $SSHKEY ${GOPATH}/src/github.com/wangaoone/storage-bandwidth-bench/init.sh "$i":~/.
  scp -i $SSHKEY ${GOPATH}/src/github.com/wangaoone/storage-bandwidth-bench/proxy.sh "$i":~/.
  scp -i $SSHKEY ${GOPATH}/src/github.com/wangaoone/storage-bandwidth-bench/update.sh "$i":~/.
  ssh -i $SSHKEY $i ./init.sh $SEQ
  ssh -i $SSHKEY $i ./update.sh
  echo "Upload finished"
  ((SEQ=SEQ+1))
done

go clean
