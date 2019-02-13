threads=(8 12 16 24 32)
iterations=(100000)
array=(4 8 16 32 64 1024 2048)
tests=20

# Options to do short threads
if [ "$1" = "shortthread" ]; then
    threads=(8 12 16)
fi
echo `java -version`
javac UnsafeMemory.java
echo "process,thread count,iteration count,array size,succeded runs,total runs,total runtime, average runtime"
for thread in ${threads[@]}; do
    for it in ${iterations[@]}; do
        for ac in ${array[@]}; do
            ./testframework.sh $thread $it $ac $tests -s -nc
        done
    done
done
