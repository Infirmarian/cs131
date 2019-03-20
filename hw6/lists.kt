//Sample

fun main(args: Array<String>) {
    var ints = listOf<Int> (0, 1, 2, 3, 4, 5)
    var strings = listOf<String> ("hello", "world", "goodbye", "darkness", "my", "old", "friend")
    var doubles = listOf<Double> (3.2, 4.34, 9.0, 0.0, 291.0, 392.443)
    var empty = listOf<Any> ()

    assert(listOf<Int>().equals(everyNth(ints, 0)))
    assert(listOf<String>().equals(everyNth(strings, -1)))
    
    assert(listOf<Any>().equals(everyNth(empty, 1)))
    assert(listOf<Int>(0, 1, 2, 3, 4, 5).equals(everyNth(ints, 1)))
    assert(listOf<Double> (3.2, 4.34, 9.0, 0.0, 291.0, 392.443).equals(everyNth(doubles, 1)))
    assert(listOf<String> ("hello", "world", "goodbye", "darkness", "my", "old", "friend").equals(everyNth(strings, 1)))

    assert(listOf<Int>(1, 3, 5).equals(everyNth(ints, 2)))
    assert(listOf<Double>(9.0, 392.443).equals(everyNth(doubles, 3)))
    assert(listOf<String>("darkness").equals(everyNth(strings, 4)))
    assert(listOf<Int>(5).equals(everyNth(ints, 6)))

    assert(listOf<String>().equals(everyNth(strings, 1000)))
    
    println("Passed all tests")
}

fun everyNth(L: List<Any>, N: Int): List<Any> {
    var accList: MutableList<Any> = mutableListOf<Any>()
    if (N <= 0)
        return accList
    var pos: Int = N -1
    while(pos < L.size){
        accList.add(L.get(pos))
        pos += N
    }
    return accList
}
