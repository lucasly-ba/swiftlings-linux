// I AM NOT DONE

enum Direction {
    case nord, sud, est, ouest
}

// TODO: renvoie la direction opposee
//   nord <-> sud, est <-> ouest
func oppose(_ d: Direction) -> Direction {
    return d
}

// ne touche pas en dessous
assert(oppose(.nord) == .sud)
assert(oppose(.sud) == .nord)
assert(oppose(.est) == .ouest)
assert(oppose(.ouest) == .est)
print("ok")
