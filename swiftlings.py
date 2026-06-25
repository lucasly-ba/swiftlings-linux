#!/usr/bin/env python3
"""petit runner facon rustlings, pour les exercices Swift.

usage:
  python swiftlings.py            mode watch (relance a chaque sauvegarde)
  python swiftlings.py list       avancement de tous les exercices
  python swiftlings.py run        verifie l'exercice en cours une fois
  python swiftlings.py hint       un indice sur l'exercice en cours
  python swiftlings.py solution   la solution complete (si tu abandonnes)
  python swiftlings.py doc        la section du tuto crea-troyes a lire
"""

import json
import os
import subprocess
import sys
import tempfile
import time

ROOT = os.path.dirname(os.path.abspath(__file__))
META = os.path.join(ROOT, "meta.json")
MARKER = "I AM NOT DONE"


def color(code, s):
    if not sys.stdout.isatty():
        return s
    return "\033[%sm%s\033[0m" % (code, s)


def green(s):  return color("32", s)
def red(s):    return color("31", s)
def yellow(s): return color("33", s)
def cyan(s):   return color("36", s)
def bold(s):   return color("1", s)


def load():
    with open(META) as f:
        data = json.load(f)
    return data["exercises"], data.get("doc", "https://swift.crea-troyes.fr/")


def read(rel):
    with open(os.path.join(ROOT, rel)) as f:
        return f.read()


def has_marker(ex):
    # only a line that is exactly the marker counts, so a mention of the
    # phrase inside a comment or instructions doesn't keep an exercise locked.
    for line in read(ex["path"]).splitlines():
        if line.strip() == "// " + MARKER:
            return True
    return False


def strip_warnings(text):
    keep = [ln for ln in text.splitlines() if "glibc not found" not in ln]
    return "\n".join(keep).strip()


def check(ex):
    """compile + execute. renvoie (ok, phase, sortie)."""
    src = os.path.join(ROOT, ex["path"])
    with tempfile.TemporaryDirectory() as d:
        binp = os.path.join(d, "ex")
        comp = subprocess.run(["swiftc", src, "-o", binp],
                              capture_output=True, text=True)
        if comp.returncode != 0:
            return False, "compile", strip_warnings(comp.stderr)
        run = subprocess.run([binp], capture_output=True, text=True)
        if run.returncode != 0:
            out = strip_warnings(run.stderr) or run.stdout.strip()
            return False, "run", out
        return True, "ok", run.stdout.strip()


def is_done(ex):
    ok, _, _ = check(ex)
    return ok and not has_marker(ex)


def current(exs):
    for ex in exs:
        if not is_done(ex):
            return ex
    return None


def cmd_list(exs, doc):
    done = 0
    for i, ex in enumerate(exs, 1):
        ok, _, _ = check(ex)
        if ok and not has_marker(ex):
            tag = green("termine")
            done += 1
        elif ok and has_marker(ex):
            tag = yellow("passe, enleve le marqueur")
        else:
            tag = red("a faire")
        print("%2d. %-12s %s" % (i, ex["name"], tag))
    print("\n%s/%d termines" % (done, len(exs)))


def cmd_run(exs, doc):
    ex = current(exs)
    if ex is None:
        print(green(bold("Tous les exercices sont termines. Bravo !")))
        return True
    ok, phase, out = check(ex)
    print(bold("Exercice: %s" % ex["name"]) + "  (%s)" % ex["path"])
    if not ok:
        if phase == "compile":
            print(red("Ca ne compile pas encore:"))
        else:
            print(red("Ca compile, mais un test echoue:"))
        if out:
            print(out)
        print("\nUn indice ?   " + cyan("python swiftlings.py hint"))
        return False
    if has_marker(ex):
        print(green("Le code passe."))
        if out:
            print("sortie: " + out)
        print(yellow("Enleve la ligne  // %s  pour valider et passer au suivant." % MARKER))
        return False
    return True


def cmd_hint(exs, doc):
    ex = current(exs)
    if ex is None:
        print(green("Plus rien a faire, tout est termine."))
        return
    print(bold("Indice (%s):" % ex["name"]))
    print(ex["hint"])
    print("\nA lire: %s  (section: %s)" % (ex.get("doc", doc), ex.get("topic", "")))


def cmd_doc(exs, doc):
    ex = current(exs)
    if ex is None:
        print(green("Tout est termine."))
        return
    print("Exercice %s, section a lire: %s" % (ex["name"], ex.get("topic", "")))
    print(ex.get("doc", doc))


def cmd_solution(exs, doc):
    ex = current(exs)
    if ex is None:
        print(green("Tout est termine."))
        return
    print(bold("Solution (%s):" % ex["name"]))
    print(ex["explain"])
    print("\n" + cyan("--- code ---"))
    print(ex["solution"])
    print(cyan("------------"))


def cmd_watch(exs, doc):
    def snap():
        s = {}
        for ex in exs:
            p = os.path.join(ROOT, ex["path"])
            try:
                s[ex["path"]] = os.path.getmtime(p)
            except OSError:
                s[ex["path"]] = 0
        return s

    cmd_run(exs, doc)
    last = snap()
    print("\n" + cyan("watch") + ": enregistre un fichier pour relancer. Ctrl-C pour quitter.")
    try:
        while True:
            time.sleep(0.4)
            now = snap()
            if now != last:
                last = now
                print("\n" + "-" * 48)
                if cmd_run(exs, doc) and current(exs) is None:
                    print(green(bold("\nTout est termine. Bien joue !")))
                    break
    except KeyboardInterrupt:
        print("\na plus.")


COMMANDS = {
    "list": cmd_list,
    "run": cmd_run,
    "verify": cmd_run,
    "hint": cmd_hint,
    "doc": cmd_doc,
    "solution": cmd_solution,
    "explain": cmd_solution,
    "watch": cmd_watch,
}


def main():
    exs, doc = load()
    cmd = sys.argv[1] if len(sys.argv) > 1 else "watch"
    handler = COMMANDS.get(cmd)
    if handler is None:
        print(__doc__)
        sys.exit(2)
    handler(exs, doc)


if __name__ == "__main__":
    main()
