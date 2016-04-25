
class val _RopeSegmentSlice is _RopeSegment
  let array: _RopeSegment
  let start: USize
  let finish: USize
  new val create(a: _RopeSegment, s: USize, f: USize) =>
    array = a; start = s; finish = f.min(a.size())
  
  fun slice(i: USize, j: USize): Rope =>
    Rope(_RopeSegmentSlice(array, start + i, (start + j).min(finish)))
  
  fun size(): USize          => finish - start
  fun apply(i: USize): U8?   => array(start + i)
  fun values(): Iterator[U8] =>
    object is Iterator[U8]
      let slice: _RopeSegmentSlice box = this
      var index: USize                 = start
      fun ref has_next(): Bool => index < slice.finish
      fun ref next(): U8? =>
        if has_next() then slice.array(index = index + 1) else error end
    end
