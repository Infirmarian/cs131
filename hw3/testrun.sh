threads=(8 12 16 24 32)
iterations=(100000)
array=(4 8 16 32 64 1024 2048)
tests=20
echo `java -version`
echo "process,thread count,iteration count,array size,runtime, average runtime"
for thread in ${threads[@]}; do
    for it in ${iterations[@]}; do
        for ac in ${array[@]}; do
            ./testframework.sh $thread $it $ac $tests -s -nc
        done
    done
done
