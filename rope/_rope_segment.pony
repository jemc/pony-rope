
interface val _RopeSegment is ReadSeq[U8]
  fun size(): USize
  fun apply(i: USize): U8?
  fun values(): Iterator[U8]
