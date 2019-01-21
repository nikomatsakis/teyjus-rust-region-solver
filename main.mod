module main.

kind region type.
kind constraint type.
type reg string -> region.
type free region -> o.
type outlives region -> region -> (list constraint) -> (list constraint) -> o.
type outlives_base region -> region -> o.
type outlives_known region -> region -> o.
type record region -> region -> (list constraint) -> (list constraint) -> o.
type test string -> o.
type test2 string -> (list constraint) -> o.
type subset region -> region -> constraint.

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

record R1 R2 Lin [subset R1 R2 | Lin] :-
  free R1,
  free R2.

% outlives_known R1 R2 :- announce (outlives_known R1 R2).
%
% `R1: R2` but excluding the reflexive relation.
outlives_known (reg "static") R2.
outlives_known R1 R2 :-
  outlives_base R1 R2.
outlives_known R1 R3 :-
  outlives_base R1 R2,
  outlives_known R2 R3.

% outlives R1 R2 :- announce (outlives R1 R2).
outlives R R Lin Lin.
outlives R1 R2 Lin Lin :-
  outlives_known R1 R2.
outlives R1 R2 Lin Lout :-
  record R1 R2 Lin Lout.
outlives R1 R3 Lin Lout :-
  outlives_known R1 R2,
  record R2 R3 Lin Lout.
outlives R1 R3 Lin Lout :-
  outlives_known R2 R3,
  record R1 R2 Lin Lout.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% (X: r1) => (X: r2)
% ==> true if r1: r2
test "transitive_upper_bound" :-
  sigma L \ pi X \ ((outlives_base X (reg "r1")) => (outlives X (reg "r2") [] L)).

test2 "transitive_upper_bound2" L2 :-
  sigma L1 \ 
  pi X \ ((outlives_base X (reg "r1")) =>
    sigma Y \ (outlives X Y [] L1, outlives Y (reg "r2") L1 L2)).
  
% (X: r3)
%
% no known bound on X, just not provable
test "transitive_no_bound" :-
  not (sigma L \ pi X \ ((outlives X (reg "r2") [] L))).
 
% (r1: X)
% ==> true if `r1: static`
test "transitive_static" :-
  pi X \ ((outlives (reg "r1") X [] [subset (reg "r1") (reg "static")])).
 
% (r1: r2)
% ==> true if `r1: static`
test "transitive_r1_r2" :-
  outlives (reg "r1") (reg "r2") [] [subset (reg "r1") (reg "r2")],
  outlives (reg "r1") (reg "r2") [] [subset (reg "r1") (reg "static")].

% (r1: r2)
% ==> true if `r1: r2`
test "transitive_r1_r2" :-
  outlives (reg "r1") (reg "r2") [] L.

% % (r1: r2); (r1: r3)
% test "transitive_r1_r2_or_r1_r3" :-
%   outlives (reg "r1") (reg "r2");
%   outlives (reg "r1") (reg "r3").
