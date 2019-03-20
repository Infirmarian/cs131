

all: lists.jar
	
check: lists.jar 
	java -jar -ea lists.jar

dist: lists.kt Makefile
	tar -czf hw6.tar.gz lists.kt Makefile

lists.jar: lists.kt
	kotlinc lists.kt -include-runtime -d lists.jar

clean:
	$(RM) hw6.tar.gz
	$(RM) lists.jar