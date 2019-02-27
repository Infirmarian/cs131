% Finite Domain Solver
tower(0, [], counts([],[],[],[])) :- !.
tower(N, T, counts(Top, Bottom, Left, Right)) :-
    fd_generate_generic_matrix(T, N, N),
    fd_unique_elements(T),
    fd_validCountIteration(T, Left, N),
    reverseAll(T, Reversed),
    fd_validCountIteration(Reversed, Right, N),
    transpose(T, Transposed, N),
    fd_validCountIteration(Transposed, Top, N),
    fd_unique_elements(Transposed),
    reverseAll(Transposed, ReverseTransposed),
    fd_validCountIteration(ReverseTransposed, Bottom, N),
    fd_label(T).

fd_label([]).
fd_label([H|T]) :- fd_labeling(H), fd_label(T).

fd_generate_generic_list([], 0, _).
fd_generate_generic_list(R, N, Max) :- N2 #= N - 1, fd_domain(FDVar, 1, Max), append([FDVar], R2, R), fd_generate_generic_list(R2, N2, Max).
fd_generate_generic_matrix([],0, _).
fd_generate_generic_matrix(R,N, Max) :- N2 #= N - 1, fd_generate_generic_list(L, Max, Max), fd_generate_generic_matrix(R2, N2, Max), append([L],R2, R).

fd_unique_elements([]).
fd_unique_elements([H|T]) :- fd_all_different(H), fd_unique_elements(T).

fd_validCountIteration([], [], _).
fd_validCountIteration([H|T], [CountH|CountT], N) :- fd_countTowersVisible(H, CountH, 0), fd_validCountIteration(T, CountT, N).

fd_countTowersVisible([], 0, _).
fd_countTowersVisible([H|T], N, Current) :- Current #< H, fd_countTowersVisible(T, N2, H), N #= N2 + 1.
fd_countTowersVisible([H|T], N, Current) :- Current #>= H, fd_countTowersVisible(T, N2, Current), N #= N2.


%base (trivial) case for a tower
plain_tower(0, [], counts([],[],[],[])) :- !.
plain_tower(N,T,counts(Top, Bottom, Left, Right)) :- 
    generateAndLengthCheck(T, N, N),
    getAllValidCountsLeftRight(T, Left),
    reverseAll(T, BoardReversed),
    getAllValidCountsLeftRight(BoardReversed, Right),
    transpose(T, BoardTranspose, N),
    getAllValidCountsLeftRight(BoardTranspose, Top),
    reverseAll(BoardTranspose, BoardReverseTranspose),
    getAllValidCountsLeftRight(BoardReverseTranspose, Bottom).

reverseAll([],[]).
reverseAll([TH|TT],Result) :- reverse(TH, L1), reverseAll(TT, R2), append([L1], R2, Result), !.
transpose(_, [], 0) :- !.
transpose(Matrix, Result, N) :- transposeRow(Matrix, N, RowIndividual), NN is N - 1, transpose(Matrix, R2, NN), append(R2, [RowIndividual], Result), !.
transposeRow([], _, []).
transposeRow([H|T], N, Result) :- transposeRow(T, N, R2), nth(N,H,A), append([A], R2, Result), !.


getAllValidCountsLeftRight([], []).
getAllValidCountsLeftRight([[1]], [1]) :- !.
getAllValidCountsLeftRight([H|T], [CountH|CountT]) :- countTowersVisible(H, CountH, 0), getAllValidCountsLeftRight(T, CountT).


% Determine if a given row fits the constraints WITHOUT Finite Domain solver
generateAndLengthCheck([], 0, _) :- !.
generateAndLengthCheck(L, Remain, N) :- NRemain is Remain - 1, 
                                        generateAndLengthCheck(R2, NRemain, N),
                                        oneThroughNList(N, BaseArray), permutation(BaseArray, T), nonDuplicateList(T, R2),
                                        append(R2, [T], L).


nonDuplicateList(_, []).
nonDuplicateList(A, [H|T]) :- nonDuplicateEntries(A, H), nonDuplicateList(A, T).
nonDuplicateEntries([], []).
nonDuplicateEntries([H|T], [A|B]) :- A \== H, nonDuplicateEntries(T, B).

oneThroughNList(0,[]):-!.
oneThroughNList(N, Result) :- N1 is N - 1, oneThroughNList(N1, R2), append(R2, [N], Result).

% Determine if there are a correct number of towers visible, eg count how many
% are being not blocked by another, higher tower

countTowersVisible([], 0, _):-!.
countTowersVisible([H|T], N, Current) :- H =< Current, countTowersVisible(T, N2, Current), N = N2, !.
countTowersVisible([H|T], N, Current) :- H > Current, countTowersVisible(T, N2, H), N is N2 + 1, !.

% CPU Time Comparison Statistics
speedup(T) :- statistics(cpu_time, _), tower(5, _, counts([3,2,1,5,2], [2,2,4,1,2],[3,2,2,1,3],[2,3,1,3,2])), statistics(cpu_time, [_,FDSolver]), 
            plain_tower(5, _, counts([3,2,1,5,2], [2,2,4,1,2],[3,2,2,1,3],[2,3,1,3,2])), statistics(cpu_time, [_,PlainSolver]), T is PlainSolver/FDSolver, !.

ambiguous(N, C, T1, T2) :- tower(N, T1, C), tower(N, T2, C), T2 \== T1.
