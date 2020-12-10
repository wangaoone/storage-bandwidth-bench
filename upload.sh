rootlist=(
  3.84.247.222
  18.234.137.115
  3.93.64.117
  54.92.153.238
  54.225.35.81
  54.152.125.134
  54.175.54.33
  18.209.105.51
  18.215.246.58
  54.80.9.126
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
