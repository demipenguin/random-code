type color = Red | Black

type 'a rbtree = Node of color * 'a * 'a rbtree * 'a rbtree | Leaf

(* TODO: use generic compare function*)

let rec member x = function
  | Leaf -> false
  | Node (_, y, left, right) ->
      x = y || x < y && member x left || x > y && member x right

let insert x t =
  let balance = function
    | Node (Black, z, Node (Red, y, Node (Red, x, a, b), c), d)
    | Node (Black, z, Node (Red, x, a, Node (Red, y, b, c)), d)
    | Node (Black, x, a, Node (Red, z, Node (Red, y, b, c), d))
    | Node (Black, x, a, Node (Red, y, b, Node (Red, z, c, d))) ->
        Node (Red, y, Node (Black, x, a, b), Node (Black, z, c, d))
    | balanced -> balanced in
  let rec ins = function
    | Leaf -> Node (Red, x, Leaf, Leaf)
    | Node (color, y, left, right) as t ->
        if x < y then balance (Node (color, y, ins left, right))
        else if x > y then balance (Node (color, y, left, ins right))
        else t in
  match ins t with
    (* Color the root with black *)
    | Node (_, y, left, right) -> Node (Black, y, left, right)
    | Leaf -> failwith "rbtree insert returns Leaf"

let construct =
  List.fold_left ~init: Leaf ~f: (fun tree value -> insert value tree)

let rec find_min = function
  | Leaf -> failwith "apply find_min on a Leaf"
  | Node (_, y, Leaf, _) -> y
  | Node (_, _, left, _) -> find_min left

let rec find_max = function
  | Leaf -> failwith "apply find_max on a Leaf"
  | Node (_, y, _, Leaf) -> y
  | Node (_, _, _, right) -> find_max right

(* tests *)

let rbt = construct [1; 3; 5; 7; 9]

let () = assert (member 1 rbt)
let () = assert (not (member 2 rbt))

