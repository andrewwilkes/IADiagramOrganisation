%Ordonnancement

% @Changelog
% 37f95e8 07/12/2017 Initialisation projet
% 900d9f9 12/12/2017 Calcule de l'aire

aire([X1,X2|[]], [Y1,Y2|[]], Tmp, RET):-
    RET1 is ((1/2*(X1/Y1)*(X2/Y2))) + Tmp,
    RET is RET1.

aire([X1,X2|L1], [Y1,Y2|L2], Tmp, RET):-
    RET1 is ((1/2*(X1/Y1)*(X2/Y2))) + Tmp,
    aire([X2|L1], [Y2|L2], RET1, RET).

aireInit(L1,L2,RET):-
    aire(L1,L2,0,RET).

maxAireInit(L1,L2,RET):-
    maxAire(L1,L2,0,[],RET).

maxAire([X1|L1], [Y1|L2], TmpAire, TmpPermu, RET):-
    aireInit(X1, Y1, AIRE),
    (   TmpAire < AIRE ->
        maxAire(L1, L2, AIRE, X1, RET)
    ;   maxAire(L1, L2, TmpAire, TmpPermu, RET)
    ).

maxAire([X1|[]], [Y1|[]], TmpAire, TmpPermu, RET):-
    aireInit(X1, Y1, AIRE),
    (   TmpAire < AIRE ->
        write(AIRE),
        write(X1),
        RET is X1
    ;   write(TmpAire),
        write(TmpPermu),
        RET is TmpPermu
    ).













