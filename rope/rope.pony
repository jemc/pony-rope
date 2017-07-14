
class val Rope is (_RopeSegment & Stringable)
  let _left:  _RopeSegment
  let _right: _RopeSegment
  let _weight: USize
  
  new val create(l: _RopeSegment = RopeNone, r: _RopeSegment = RopeNone) =>
    _left   = l
    _right  = r
    _weight = l.size()
  
  fun size(): USize =>
    _weight + _right.size()
  
  fun apply(i: USize): U8? =>
    if _weight <= i
    then _right(i - _weight)
    else _left(i)
    end
  
  fun slice(i: USize, j: USize): Rope =>
    if j <= i then return Rope(RopeNone) end
    
    match ((_weight <= i), (_weight < j))
    | (true,  true)  => _slice_segment(_right, i - _weight, j - _weight)
    | (false, false) => _slice_segment(_left, i, j)
    | (false, true)  => Rope(_slice_segment(_left, i, _weight),
                             _slice_segment(_right, 0, j - _weight))
    else Rope(RopeNone)
    end
  
  fun tag _slice_segment(seg': _RopeSegment, i: USize, j: USize): Rope =>
    match seg'
    | let seg: _RopeSegmentSlice => seg.slice(i, j)
    | let seg: Rope              => seg.slice(i, j)
    | let seg: RopeNone          => Rope(RopeNone)
    else                            Rope(_RopeSegmentSlice(seg', i, j))
    end
  
  fun values(): Iterator[U8] =>
    object is Iterator[U8]
      let _left_values:  Iterator[U8] = _left.values()
      let _right_values: Iterator[U8] = _right.values()
      fun ref has_next(): Bool => _left_values.has_next()
                               or _right_values.has_next()
      fun ref next(): U8?      => try _left_values.next()
                                 else _right_values.next() end
    end
  
  fun val add(that: _RopeSegment): Rope =>
    // TODO: balance the tree here when helpful
    if _right is RopeNone then
      if _left is RopeNone then
        Rope(that)
      else
        Rope(_left, that)
      end
    else
      Rope(this, that)
    end
  
  fun _copy_into_string(dest: String iso): String iso^ =>
    _copy_seg_into_string(_right, _copy_seg_into_string(_left, consume dest))
  
  fun tag _copy_seg_into_string(source: _RopeSegment, dest: String iso):
    String iso^
  =>
    match source
    | let s: Rope     => s._copy_into_string(consume dest)
    | let s: RopeNone => consume dest
    else                 dest.append(source); consume dest
    end
  
  fun string(): String iso^ =>
    let len = size()
    let out = recover iso String(len) end
    _copy_into_string(consume out)
