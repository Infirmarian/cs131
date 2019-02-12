#!/bin/bash
# Variables. Change these to significantly modify the system
threads=12
iterations=100000
maxval=64
sum=0
testcount=20
timeout=0.5

if [ "$1" = "-s" ]; then
    silent=1
else
    silent=0
fi

javac UnsafeMemory.java
if [ $? -ne 0 ]; then
    echo "Failed to compile. See error message above"
fi

echo "########### SYNCHRONIZED #############"
for((i=0;i<$testcount;i++)); do
    val=$(java UnsafeMemory Synchronized $threads $iterations $maxval \
     $((RANDOM % $maxval)) $((RANDOM % $maxval)) $((RANDOM % $maxval))\
     $((RANDOM % $maxval)) $((RANDOM % $maxval)) $((RANDOM % $maxval))\
     $((RANDOM % $maxval)) | grep -o -E "[0-9]+\.[0-9]+")
     sum=$(echo $sum + $val | bc)
     if [ $silent -eq 0 ]; then 
     echo "$val" 
     fi
done
avg=$(echo $sum / $testcount | bc)
echo "TOTAL TESTS: $testcount"
echo "AVERAGE SYNCHRONIZED: $avg"


echo "########## UNSYNCHRONIZED ############"
sum=0
lowertest=$testcount
for((i=0;i<$testcount;i++)); do
     java UnsafeMemory Unsynchronized $threads $iterations $maxval \
     $((RANDOM % $maxval)) $((RANDOM % $maxval)) $((RANDOM % $maxval))\
     $((RANDOM % $maxval)) $((RANDOM % $maxval)) $((RANDOM % $maxval))\
     $((RANDOM % $maxval)) 2>/dev/null \
     | grep -o -E "[0-9]+\.[0-9]+" > temp.num 2>/dev/null &
     sleep $timeout
     if ps | grep -q "[j]ava UnsafeMemory"; then
        kill $(ps | grep "[j]ava UnsafeMemory" | grep -o -E "^[0-9]{5}") 2>/dev/null
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
echo "TOTAL TESTS: $lowertest"
echo "AVERAGE UNSYNCHRONIZED: $avg"



echo "############# GetNSet ###############"
sum=0
lowertest=$testcount
for((i=0;i<$testcount;i++)); do
     java UnsafeMemory GetNSet $threads $iterations $maxval \
     $((RANDOM % $maxval)) $((RANDOM % $maxval)) $((RANDOM % $maxval))\
     $((RANDOM % $maxval)) $((RANDOM % $maxval)) $((RANDOM % $maxval))\
     $((RANDOM % $maxval)) 2>/dev/null \
     | grep -o -E "[0-9]+\.[0-9]+" > temp.num 2>/dev/null &
     sleep $timeout
     if ps | grep -q "[j]ava UnsafeMemory"; then
        kill $(ps | grep "[j]ava UnsafeMemory" | grep -o -E "^[0-9]{5}") 2>/dev/null
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
echo "TOTAL TESTS: $lowertest"
echo "AVERAGE GetNSet: $avg"



echo "############ BetterSafe ##############"
for((i=0;i<$testcount;i++)); do
    val=$(java UnsafeMemory BetterSafe $threads $iterations $maxval \
     $((RANDOM % $maxval)) $((RANDOM % $maxval)) $((RANDOM % $maxval))\
     $((RANDOM % $maxval)) $((RANDOM % $maxval)) $((RANDOM % $maxval))\
     $((RANDOM % $maxval)) | grep -o -E "[0-9]+\.[0-9]+")
     sum=$(echo $sum + $val | bc)
     if [ $silent -eq 0 ]; then 
     echo "$val" 
     fi
done
avg=$(echo $sum / $testcount | bc)
echo "TOTAL TESTS: $testcount"
echo "AVERAGE SYNCHRONIZED: $avg"


# Cleanup
rm temp.num

if [ "$2" = "-c" ]; then
    rm *.class
fi

