
primitive RopeNone is _RopeSegment
  fun size(): USize          => 0
  fun apply(i: USize): U8?   => error
  fun values(): Iterator[U8] =>
    object ref is Iterator[U8]
      fun ref has_next(): Bool => false
      fun ref next(): U8?      => error
    end
