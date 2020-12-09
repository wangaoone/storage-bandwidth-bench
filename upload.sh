rootlist=(
  ubuntu@172.31.7.84
  ubuntu@172.31.10.85
  ubuntu@172.31.6.88
  ubuntu@172.31.0.136
  ubuntu@172.31.8.75
  ubuntu@172.31.15.236
  ubuntu@172.31.6.45
  ubuntu@172.31.13.111
  ubuntu@172.31.15.208
  ubuntu@172.31.15.211
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
