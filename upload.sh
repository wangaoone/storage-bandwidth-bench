rootlist=(
  3.81.173.58
  52.71.178.255
  18.234.48.105
)

GO111MODULE=off GOOS=linux go build
SSHKEY=~/.ssh/ops.pem

SEQ=0
for i in "${rootlist[@]}"; do
  echo "$i"
  scp -i $SSHKEY ${GOPATH}/src/github.com/wangaoone/storage-bandwidth-bench/storage-bandwidth-bench ubuntu@$i:~/.
  scp -i $SSHKEY ${GOPATH}/src/github.com/wangaoone/storage-bandwidth-bench/init.sh ubuntu@$i:~/.
  scp -i $SSHKEY ${GOPATH}/src/github.com/wangaoone/storage-bandwidth-bench/proxy.sh ubuntu@$i:~/.
  scp -i $SSHKEY ${GOPATH}/src/github.com/wangaoone/storage-bandwidth-bench/update.sh ubuntu@$i:~/.
  ssh -i $SSHKEY ubuntu@$i ./init.sh $SEQ $i
  ssh -i $SSHKEY ubuntu@$i ./update.sh
  echo "Upload finished"
  ((SEQ=SEQ+1))
done

go clean
