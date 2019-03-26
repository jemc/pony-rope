
use "ponytest"
use ".."

class RopeTest is UnitTest
  new iso create() => None
  fun name(): String => "Rope"

  fun apply(h: TestHelper) =>
    var rope = Rope
    h.assert_eq[USize](0, rope.size())
    h.assert_eq[String]("", rope.string())

    rope = rope + "abc" + "def" + "ghi" + "jkl"
    h.assert_eq[USize](12, rope.size())
    h.assert_eq[String]("abcdefghijkl", rope.string())

    rope = rope.slice(2, 8)
    h.assert_eq[USize](6, rope.size())
    h.assert_eq[String]("cdefgh", rope.string())

    rope = rope + "XYZ"
    h.assert_eq[USize](9, rope.size())
    h.assert_eq[String]("cdefghXYZ", rope.string())

    rope = rope.slice(5, 20)
    h.assert_eq[USize](4, rope.size())
    h.assert_eq[String]("hXYZ", rope.string())

class RopeDropTest is UnitTest
  fun name(): String => "Rope/drop"

  fun apply(h: TestHelper) =>
    var rope = Rope
    h.assert_eq[USize](0, rope.drop(10).size())
    h.assert_eq[String]("", rope.drop(10).string())

    h.assert_eq[USize](0, rope.drop(0).size())
    h.assert_eq[String]("", rope.drop(0).string())

    rope = rope + "abc" + "d" + "ef" + "ghijkl"

    h.assert_eq[USize](10, rope.drop(2).size())
    h.assert_eq[String]("cdefghijkl", rope.drop(2).string())

    h.assert_eq[USize](rope.size(), rope.drop(0).size())
    h.assert_eq[String](rope.string(), rope.drop(0).string())

    h.assert_eq[USize](7, rope.drop(5).size())
    h.assert_eq[String]("fghijkl", rope.drop(5).string())

    h.assert_eq[USize](0, rope.drop(12).size())
    h.assert_eq[String]("", rope.drop(12).string())

class RopeTakeTest is UnitTest
  fun name(): String => "Rope/take"

  fun apply(h: TestHelper) =>
    var rope = Rope
    h.assert_eq[USize](0, rope.take(0).size())
    h.assert_eq[String]("", rope.take(0).string())

    h.assert_eq[USize](0, rope.take(7).size())
    h.assert_eq[String]("", rope.take(7).string())

    rope = rope + "abc" + "d" + "efgh" + "ijkl"

    h.assert_eq[USize](rope.size(), rope.take(rope.size()).size())
    h.assert_eq[String](rope.string(), rope.take(rope.size()).string())

    h.assert_eq[USize](4, rope.take(4).size())
    h.assert_eq[String]("abcd", rope.take(4).string())

class RopeFindTest is UnitTest
  fun name(): String => "Rope/find"

  fun assert_found_at(at_index: USize, actual: (Bool, USize), h: TestHelper, loc: SourceLoc = __loc) =>
    h.assert_true(actual._1, "expected found, but was not-found" where loc = loc)
    h.assert_eq[USize](at_index, actual._2 where loc = loc)

  fun assert_not_found(actual: (Bool, USize), h: TestHelper, loc: SourceLoc = __loc) =>
    h.assert_false(actual._1, "expected not-found, but was found at " + actual._2.string() where loc = loc)

  fun apply(h: TestHelper) =>
    var rope = Rope
    assert_not_found(rope.find("def"), h)
    assert_not_found(rope.find(""), h)

    rope = rope + "abc" + "de"

    assert_not_found(rope.find(""), h)
    assert_found_at(0, rope.find("a"), h)
    assert_found_at(0, rope.find("abcde"), h)
    assert_not_found(rope.find("abcdef"), h)

    assert_found_at(2, rope.find("cd"), h)

    rope = rope.drop(2) + "fg" + "hijkl"

    assert_found_at(6, rope.find("ijk"), h)
    assert_not_found(rope.find("abc"), h)
    assert_found_at(0, rope.find(rope), h)
    assert_found_at(2, rope.find(rope.drop(2)), h)
