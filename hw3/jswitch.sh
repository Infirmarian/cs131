./testrun.sh > result11.csv
echo "Done with Java 11, switching to Java 9"
# Switch Java Versions
export PATH="/usr/local/cs/jdk-9/bin:$PATH"
rm *.class # remove old compiled programs
./testrun.sh > result9.csv
echo "Done with testing"
