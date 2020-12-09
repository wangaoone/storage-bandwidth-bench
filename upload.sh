rootlist=(
  ubuntu@172.31.44.101
  ubuntu@172.31.45.177
  ubuntu@172.31.40.248
  ubuntu@172.31.47.55
  ubuntu@172.31.46.32
  ubuntu@172.31.42.159
  ubuntu@172.31.34.105
  ubuntu@172.31.34.216
  ubuntu@172.31.44.140
  ubuntu@172.31.33.123
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
