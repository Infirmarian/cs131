./testrun.sh > result11.csv
echo -e "\nDone with Java 11, switching to Java 9\n"
# Switch Java Versions
export PATH="/usr/local/cs/jdk-9/bin:$PATH"
rm *.class # remove old compiled programs
./testrun.sh shortthread > result9.csv
echo -e "Done with testing"
