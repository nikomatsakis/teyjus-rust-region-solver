module main.

kind region type.
type reg string -> region.
type free region -> o.
type outlives region -> region -> o.
type outlives_base region -> region -> o.
type outlives_known region -> region -> o.
type record region -> region -> o.
type test string -> o.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

type announce, spy    o -> o.
type bracket          string -> o -> string -> o.  % Auxiliary

bracket Pre G Post :- print Pre, term_to_string G S, print S, print Post.
announce G :- bracket ">>" G "\n", fail.
spy G :- (bracket ">Entering " G "\n", G, bracket ">Success  " G "\n";
          bracket ">Leaving  " G "\n", fail).
          
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

free (reg "r1").
free (reg "r2").
free (reg "r3").
free (reg "static").

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

record R1 R2 :-
  free R1,
  free R2,
  term_to_string R1 S1,
  term_to_string R2 S2,
  print S1,
  print ":",
  print S2,
  print "\n".

% outlives_known R1 R2 :- announce (outlives_known R1 R2).
outlives_known (reg "static") R2.
outlives_known R1 R2 :-
  outlives_base R1 R2.
outlives_known R1 R3 :-
  outlives_base R1 R2,
  outlives_known R2 R3.

% outlives R1 R2 :- announce (outlives R1 R2).
outlives R R.
outlives R1 R2 :-
  outlives_known R1 R2.
outlives R1 R2 :-
  record R1 R2.
outlives R1 R3 :-
  outlives_known R1 R2,
  record R2 R3.
outlives R1 R3 :-
  outlives_known R2 R3,
  record R1 R2.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% (X: r1) => (X: r2)
% ==> true if r1: r2
test "transitive_upper_bound" :-
  pi X \ ((outlives_base X (reg "r1")) => (outlives X (reg "r2"))).

% (X: r3)
%
% no known bound on X, just not provable
test "transitive_no_bound" :-
  pi X \ ((outlives X (reg "r2"))).

% (r1: X)
% ==> true if `r1: static`
test "transitive_static" :-
  pi X \ ((outlives (reg "r1") X)).

% (r1: r2)
% ==> true if `r1: static`
test "transitive_r1_r2" :-
  outlives (reg "r1") (reg "r2").

% (r1: r2)
% ==> true if `r1: r2`
test "transitive_r1_r2" :-
  outlives (reg "r1") (reg "r2").

% (r1: r2); (r1: r3)
test "transitive_r1_r2_or_r1_r3" :-
  outlives (reg "r1") (reg "r2");
  outlives (reg "r1") (reg "r3").
