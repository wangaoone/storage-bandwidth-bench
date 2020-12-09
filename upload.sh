rootlist=(
  ubuntu@172.31.41.46
  ubuntu@172.31.33.1
  ubuntu@172.31.42.253
  ubuntu@172.31.42.157
  ubuntu@172.31.43.26
  ubuntu@172.31.45.184
  ubuntu@172.31.33.149
  ubuntu@172.31.43.33
  ubuntu@172.31.34.49
  ubuntu@172.31.41.209
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
