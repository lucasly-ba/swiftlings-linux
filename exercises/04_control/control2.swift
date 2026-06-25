// I AM NOT DONE

// TODO: avec un switch, renvoie l'action selon la couleur du feu:
//   "rouge" -> "stop", "orange" -> "ralentir", "vert" -> "go"
//   n'importe quoi d'autre -> "inconnu"
func action(_ feu: String) -> String {
    return ""
}

// ne touche pas en dessous
assert(action("rouge") == "stop")
assert(action("orange") == "ralentir")
assert(action("vert") == "go")
assert(action("bleu") == "inconnu")
print("ok")
