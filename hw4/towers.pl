
tower(0, [], counts([],[],[],[])) :- !.
tower(N, T, counts(Top, Bottom, Left, Right)) :- true.


%base (trivial) case for a tower
plain_tower(0, [], counts([],[],[],[])) :- !.
plain_tower(N,T,counts(Top, Bottom, Left, Right)) :- 
    generateAndLengthCheck(T, N, N),
    transpose(T, BoardTranspose, N),
    generateAndLengthCheck(BoardTranspose, N, N),
    getAllValidCountsLeftRight(T, Left),
    reverseAll(T, BoardReversed),
    getAllValidCountsLeftRight(BoardReversed, Right),
    getAllValidCountsLeftRight(BoardTranspose, Top),
    reverseAll(BoardTranspose, BoardReverseTranspose),
    getAllValidCountsLeftRight(BoardReverseTranspose, Bottom).

reverseAll([],[]).
reverseAll([TH|TT],Result) :- reverse(TH, L1), reverseAll(TT, R2), append([L1], R2, Result), !.
transpose(_, [], 0).
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
                                        oneThroughNList(N, BaseArray), permutation(BaseArray, T), 
                                        append(R2, [T], L).

validTowerRowsNFD([], _).
validTowerRowsNFD([H|T], N) :- validTowerRowNFD(H, N), validTowerRowsNFD(T,N).

validTowerRowNFD(T, N) :- oneThroughNList(N, BaseArray), permutation(BaseArray, T).

oneThroughNList(0,[]):-!.
oneThroughNList(N, Result) :- N1 is N - 1, oneThroughNList(N1, R2), append(R2, [N], Result).

% Determine if there are a correct number of towers visible, eg count how many
% are being not blocked by another, higher tower

countTowersVisible([], 0, _):-!.
countTowersVisible([H|T], N, Current) :- H =< Current, countTowersVisible(T, N2, Current), N = N2, !.
countTowersVisible([H|T], N, Current) :- H > Current, countTowersVisible(T, N2, H), N is N2 + 1, !.

