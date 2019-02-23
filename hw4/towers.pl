
%base (trivial) case for a tower
tower(0, [], counts([],[],[],[])) :- !.
tower(N,[TH|TT],counts(Top, Bottom, Left, Right)) :- 
    getAllValidCountsLeftRight([TH|TT], Left),
    reverseAll([TH|TT], BoardReversed),
    getAllValidCountsLeftRight(BoardReversed, Right),
    transpose([TH|TT], BoardTranspose, N),
    getAllValidCountsLeftRight(BoardTranspose, Top),
    reverseAll(BoardTranspose, BoardReverseTranspose),
    getAllValidCountsLeftRight(BoardReverseTranspose, Bottom),
    validTowerRows([TH|TT], N),
    validTowerRows(BoardTranspose, N).

reverseAll([],[]).
reverseAll([TH|TT],Result) :- reverse(TH, L1), reverseAll(TT, R2), append([L1], R2, Result).

transpose(_, [], 0).
transpose(Matrix, Result, N) :- transposeRow(Matrix, N, RowIndividual), NN is N - 1, transpose(Matrix, R2, NN), append(R2, [RowIndividual], Result).

transposeRow([], _, []).
transposeRow([H|T], N, Result) :- transposeRow(T, N, R2), nth(N,H,A), append([A], R2, Result).


getAllValidCountsLeftRight([], []).
getAllValidCountsLeftRight([[1]], [1]) :- !.
getAllValidCountsLeftRight([H|T], [CountH|CountT]) :- validCountTowersVisible(H, CountH, 0), getAllValidCountsLeftRight(T, CountT).




% Determine if a given row fits the constraints of the tower problem
% (Length N, max value N, min value 1, add elements different)
validTowerRow([H], N) :- N #= 1, !.
validTowerRow([H|T], N) :-  fd_domain(FDList, [H|T]), 
                            fd_all_different([H|T]), 
                            X #= 1, 
                            Y #= N, 
                            fd_max(FDList, Y), 
                            fd_min(FDList, X).

validTowerRows([], N).
validTowerRows([H|T], N) :- validTowerRow(H, N), validTowerRows(T,N).

% Determine if a given row fits the constraints WITHOUT Finite Domain solver
validTowerRowNFD([H|T], N) :-   max_list([H|T], N), 
                                min_list([H|T], 1), 
                                length([H|T], N), 
                                sort([H|T], R), 
                                length(R, N).


% Determine if there are a correct number of towers visible, eg count how many
% are being not blocked by another, higher tower
maxHeight(N1, N2, R) :- N1 #>= N2, R #= N1.
maxHeight(N1, N2, R) :- N2 #>= N1, R #= N2.
heightGT(N1, N2, R) :- N1 #>= N2, R #= 1.
heightGT(N1, N2, R) :- N1 #=< N2, R #= 0.

validCountTowersVisible([], 0, _).
validCountTowersVisible([H|T], N, CurrentHeight) :- maxHeight(H, CurrentHeight, R), 
                                                    validCountTowersVisible(T, N2, R), 
                                                    heightGT(H, CurrentHeight, Diff),
                                                    N #= Diff + N2,!.