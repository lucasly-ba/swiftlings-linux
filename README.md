# swift-learn

Mon environnement Nix pour apprendre Swift en suivant
<https://swift.crea-troyes.fr/>.

Il tourne avec **Swift 5.10.1**. nixpkgs n'a jamais empaqueté la 5.9 (il est
passé directement de 5.8 a 5.10.1), et la 5.10.1 contient tout ce que fait la
5.9, donc le tuto passe sans souci.

## Lancer l'environnement

Le dossier contient un `.envrc` (`use flake`). Avec direnv :

```sh
direnv allow      # une seule fois, ensuite ca se charge tout seul en entrant dans le dossier
```

Sans direnv :

```sh
nix develop
```

## Les commandes

| Commande               | A quoi ca sert                                              |
|------------------------|------------------------------------------------------------|
| `swift`                | REPL interactif (Swift pur)                                |
| `srun fichier.swift`   | compile puis exécute un fichier. A utiliser des qu'il y a `import Foundation` |
| `swiftc fichier.swift` | compile vers un binaire (`./fichier`)                      |
| `swift run`            | lance un paquet SwiftPM (voir `example/`)                  |
| `swift-format ...`     | formate le code                                            |

### Pourquoi `srun` et pas `swift fichier.swift` ?

Sur Linux avec nixpkgs, le mode interprété `swift fichier.swift` ne trouve pas
le module `Foundation`. Deux façons qui marchent a tous les coups :

1. `srun fichier.swift`, qui compile puis exécute (le script est fourni par le flake).
2. un paquet SwiftPM avec `swift run` (voir le dossier `example/`).

`swift fichier.swift` reste pratique pour du Swift pur, sans `import`.

L'avertissement `glibc not found ...` est cosmétique, la sortie est bonne, on
l'ignore.

## Le contenu

- `flake.nix` : la définition de l'environnement (versions figées dans `flake.lock`)
- `.envrc` : l'intégration direnv
- `hello.swift` : un premier exemple, `srun hello.swift`
- `example/` : un petit paquet SwiftPM, `cd example && swift run`
