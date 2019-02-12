#!/bin/bash

if [ "$1" = "fetch" ]; then 
    curl http://web.cs.ucla.edu/classes/winter19/cs131/hw/jmm.jar > jmm.jar
    jar -xf jmm.jar NullState.java State.java SwapTest.java SynchronizedState.java META-INF
fi

if [ "$1" = "clean" ]; then
    rm *.class
    rm NullState.java
    rm State.java
    rm SwapTest.java
    rm SynchronizedState.java
#    rm UnsafeMemory.java
    rm -r META-INF
fi