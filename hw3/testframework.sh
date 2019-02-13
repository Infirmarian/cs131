#!/bin/bash
# Variables. Change these to significantly modify the system

if [ -z "$1" ]; then
echo "Usage: ./testframework.sh threads iterations arraySize testCount [-s silent] [-nc don't recompile]"
exit 1
fi

# Results are in the format
# process,thread count,iteration count,array size,succeded runs,total runs,total runtime, average runtime
threads=$1
iterations=$2
maxval=64
sum=0
testcount=$4
timeout=0.5
array_size=$3


# Generate (a large number) of random digits
count=1
while [ "$count" -le $array_size ]; do
 randarray[$count]=$(($RANDOM%$maxval))
 let "count += 1"
done

if [ "$5" = "-s" ]; then
    silent=1
else
    silent=0
fi
if [ "$6" != "-nc" ]; then
    javac UnsafeMemory.java
    if [ $? -ne 0 ]; then
        echo "Failed to compile. See error message above"
    fi
fi

echo -n "Null,$threads,$iterations,$array_size,"
for((i=0;i<$testcount;i++)); do
    val=$(java UnsafeMemory Null $threads $iterations $maxval "${randarray[@]}" \
    | grep -o -E "[0-9]+\.[0-9]+")
     sum=$(echo $sum + $val | bc)
     if [ $silent -eq 0 ]; then 
        echo "$val" 
     fi
done
echo -n "$testcount,"
echo -n "$testcount,"
echo -n "$sum,"
avg=$(echo $sum / $testcount | bc)
echo "$avg"

sum=0
echo -n "Synchronized,$threads,$iterations,$array_size,"
for((i=0;i<$testcount;i++)); do
    val=$(java UnsafeMemory Synchronized $threads $iterations $maxval  "${randarray[@]}" \
     | grep -o -E "[0-9]+\.[0-9]+")
     sum=$(echo $sum + $val | bc)
     if [ $silent -eq 0 ]; then 
     echo "$val" 
     fi
done
echo -n "$testcount,"
echo -n "$testcount,"
echo -n "$sum,"
avg=$(echo $sum / $testcount | bc)
echo "$avg"


echo -n "Unsynchronized,$threads,$iterations,$array_size,"
sum=0
lowertest=$testcount
for((i=0;i<$testcount;i++)); do
     java UnsafeMemory Unsynchronized $threads $iterations $maxval "${randarray[@]}" \
     2>/dev/null \
     | grep -o -E "[0-9]+\.[0-9]+" > temp.num &
     sleep $timeout
     if ps | grep -q "[j]ava"; then
        kill $(ps | grep "[j]ava" | awk '{print $1}') 2>/dev/null
        let "lowertest--"
     else
        val=$(<temp.num)
        sum=$(echo $sum + $val | bc)
        if [ $silent -eq 0 ]; then
         echo "$val" 
        fi
     fi
done
if [ $lowertest -eq 0 ]; then
    avg="NaN"
else
    avg=$(echo $sum / $lowertest | bc)
fi
echo -n "$lowertest,"
echo -n "$testcount,"
echo -n "$sum,"
echo "$avg"



echo -n "GetNSet,$threads,$iterations,$array_size,"
sum=0
lowertest=$testcount
for((i=0;i<$testcount;i++)); do
     java UnsafeMemory GetNSet $threads $iterations $maxval "${randarray[@]}" \
     2>/dev/null \
     | grep -o -E "[0-9]+\.[0-9]+" > temp.num &
     sleep $timeout
     if ps | grep -q "[j]ava"; then
        kill $(ps | grep "[j]ava" | awk '{print $1}') 2>/dev/null
        let "lowertest--"
     else
        val=$(<temp.num)
        sum=$(echo $sum + $val | bc)
        if [ $silent -eq 0 ]; then
         echo "$val" 
        fi
     fi
done
if [ $lowertest -eq 0 ]; then
    avg="NaN"
else
    avg=$(echo $sum / $lowertest | bc)
fi
echo -n "$lowertest,"
echo -n "$testcount,"
echo -n "$sum,"
echo "$avg"


sum=0
echo -n "BetterSafe,$threads,$iterations,$array_size,"
for((i=0;i<$testcount;i++)); do
    val=$(java UnsafeMemory BetterSafe $threads $iterations $maxval  "${randarray[@]}" \
     | grep -o -E "[0-9]+\.[0-9]+")
     sum=$(echo $sum + $val | bc)
     if [ $silent -eq 0 ]; then 
     echo "$val" 
     fi
done
avg=$(echo $sum / $testcount | bc)
echo -n "$testcount,"
echo -n "$testcount,"
echo -n "$sum,"
echo "$avg"


# Cleanup
rm temp.num

if [ "$2" = "-c" ]; then
    rm *.class
fi

