
/*
Calcule l'aire entre 2 caractéristiques et la met dans une liste

Paramètre 1 : Le diagramme
Paramètre 2 : Liste des dimensions
Paramètre 3 : Résultat -> L'aire entre 2 dimensions

Modifications :
9866c62 QUINQUENEL Nicolas 27/12/2017 Création de la méthode pour calculer l'aire entre 2 dimensions

Pré-Condition : Le paramètre 1 est un diagramme, le paramètre 2 est une liste de dimension(s) non vide
Post-Condition : Le paramètre 3 est une liste de float
*/
airePosInit(Diag,[Dim1|ListDim], RET):-
    insertFin(Dim1, [Dim1|ListDim], N1),
    airePos(Diag, N1, [], RET).

airePos(Diag, [Dim1, Dim2], TmpArray, RET):-
    value(Diag, Dim1, X1),
    value(Diag, Dim2, X2),
    max(Dim1, Y1),
    max(Dim2, Y2),
    Tmp2 is ((1/2*(X1/Y1)*(X2/Y2))),
    insertFin(Tmp2, TmpArray, RET).

airePos(Diag, [Dim1, Dim2|ListDim], TmpArray, RET):-
    value(Diag, Dim1, X1),
    value(Diag, Dim2, X2),
    max(Dim1, Y1),
    max(Dim2, Y2),
    RET1 is ((1/2*(X1/Y1)*(X2/Y2))),
    insertFin(RET1, TmpArray, TmpArray2),
    airePos(Diag, [Dim2|ListDim], TmpArray2, RET).

/*
Ajoute la liste des aires entre 2 caractéristiques de tous les graphes
dans une liste globale

Paramètre 1 : Liste des diagrammes
Paramètre 2 : Liste des dimensions
Paramètre 3 : Résultat -> Liste des aires entre 2 dimensions pour chaque diagramme de la liste

Modifications :
9866c62 QUINQUENEL Nicolas 27/12/2017 Méthode calcule aire entre chaque dimensions (ordonnancement)

Pré-Condition : Les paramètres 1 et 2 sont des listes non vides
Post-Condition : Le paramètre 3 est une liste de liste de float non vides
*/
sommeAirePosInit(ListDiag, ListDim, RET):-
    sommeAirePos(ListDiag, ListDim, [], RET).

sommeAirePos([Diag|ListDiag], ListDim, TmpArray, RET):-
    airePosInit(Diag, ListDim, ListAire),
    insertFin(ListAire, TmpArray, TmpArray2),
    sommeAirePos(ListDiag, ListDim, TmpArray2, RET).

sommeAirePos([Diag], ListDim, TmpArray, RET):-
    airePosInit(Diag, ListDim, ListAire),
    insertFin(ListAire, TmpArray, RET).

/*
Parcours toutes les liste d'aires et calcule la différence avec les
autres listes d'aires

Paramètre 1 : La liste des aires à comparer
Paramètre 2 : la liste des aires qui vont être comparé au paramètre 1
Paramètre 3 : Résultat -> La liste contenant les différences d'aires pour chaque diagramme (entre chaque diagramme)

Modifications :
a7f8318 QUINQUENEL Nicolas 28/12/2017 Méthode pour calculer la différence entre les graphes (ordonnancement)

Pré-Condition : Les paramètres 1 et 2 sont des listes de listes de float
Post-Condition : Le paramètre 3 est une liste de listes de listes de float
*/
differenceAireMultInit(ListAireBase, ListAire, ListRet):-
    differenceAireMult(ListAireBase, ListAire, [], ListRet).

differenceAireMult([AireBase|ListAireBase], [_|ListAire], TmpRet, ListRet):-
    differenceAireInit(AireBase, ListAire, Ret),
    insertFin(Ret, TmpRet, TmpRet2),
    differenceAireMult(ListAireBase, ListAire, TmpRet2, ListRet).

differenceAireMult([_|_], _, TmpRet, ListRet):-
    ListRet = TmpRet.

/*
Pour une liste d'aire, on va la comparer à toutes les autres listes
d'aires (liste d'aire 1 va voir les listes 2, 3, 4, etc. et la 2eme ne
verra que la 3, 4 etc mais pas celle d'avant)

Paramètre 1 : La liste d'aires entre les dimensions pour 1 diagramme
Paramètre 2 : La liste des aires entre les dimensions pour les autres diagrammes
Paramètre 3 : Résultat -> La liste des différences d'aires entre les dimensions pour 1 diagramme comparé aux autres

Modifications :
a7f8318 QUINQUENEL Nicolas 28/12/2017 Méthode pour calculer la différence entre les graphes (ordonnancement)

Pré-Condition : Le paramètre 1 est une liste de float, le paramètre 2 est une liste de listes de float
Post-Condition : Le paramètre 3 est une liste de liste(s) de float
*/
differenceAireInit(AireBase, ListAire, ListRet):-
    differenceAire(AireBase, ListAire, [], ListRet).

differenceAire(AireBase, [List|ListAire], TmpRet, ListRet):-
    diffCalculeInit(AireBase, List, Ret),
    insertFin(Ret, TmpRet, TmpRet2),
    differenceAire(AireBase, ListAire, TmpRet2, ListRet).

differenceAire(AireBase, [List], TmpRet, ListRet):-
    diffCalculeInit(AireBase, List, Ret),
    insertFin(Ret, TmpRet, ListRet).

/*
Calcule la différence entre chaque dimension pour les 2 listes d'aires (fonction de ressemblance)

Paramètre 1 : Liste des aires entre chaque dimension pour le diagramme comparé
Paramètre 2 : Liste des aires entre chaque dimension pour un autre diagramme
Paramètre 3 : Résultat -> Liste des différences d'aires pour le diagramme comparé

Modifications :
a7f8318 QUINQUENEL Nicolas 28/12/2017 Création de la méthode utilisant la fonction de ressemblance

Pré-Condition : Les paramètres 1 et 2 sont des listes de float
Post-Condition : Le paramètre 3 est un float
*/
diffCalculeInit(AireBase, ListAire, Ret):-
    diffCalcule(AireBase, ListAire, 0, Ret).

diffCalcule([ValBase|AireBase], [ValAire|ListAire], TmpRet, Ret):-
    Tmp1 is (((ValBase - ValAire)*(ValBase - ValAire)) + TmpRet),
    diffCalcule(AireBase, ListAire, Tmp1, Ret).

diffCalcule([_], [_], TmpRet, Ret):-
    Ret = TmpRet.

/*
Créer une liste [value, diag] entre un diagramme et la valeur
correspondant a la différence d'air du diagramme 1 et un diagramme
suivant. Permet de trier en gardant la correspondance par la suite.

Paramètre 1 : Liste contenant les valeurs
Paramètre 2 : Liste contenant les diagrammes
Paramètre 3 : Résultat -> Liste contenant les valeurs associées aux diagrammes

Modifications :
c6ca7e8 QUINQUENEL Nicolas 30/12/2017 Création de la méthode pour ajouter une key/value

Pré-Condition : Les paramètres 1 et 2 sont des listes de listes non vides
Post-Condition : Le paramètre 3 est une liste de listes
*/
creerKeyValueListInit([List1|_], [_|ListDiag], Ret):-
    creerKeyValueList(List1, ListDiag, [], [], Ret).

creerKeyValueList([Value|List], [Diag|ListDiag], EmptyArray, RetTmp, Ret):-
    insertFin(Value, EmptyArray, New),
    insertFin(Diag, New, RetTmp2),
    insertFin(RetTmp2, RetTmp, NewRet),
    creerKeyValueList(List, ListDiag, [], NewRet, Ret).

creerKeyValueList(_, _, _, RetTmp, Ret):-
    Ret = RetTmp.

/*
Enlève les valeurs des tuples afin de retourner seulement l'ordonnancement des diagrammes (ajoute le diagramme 1 automatiquement en premier)

Paramètre 1 : Liste contenant les valeurs associées aux diagrammes
Paramètre 2 : Résultat -> Liste contenant seulement les diagrammes

Modifications :
c6ca7e8 QUINQUENEL Nicolas 30/12/2017 Création de la méthode pour supprimer une key/value

Pré-Condition : Le paramètre 1 est une liste de listes non vides
Post-Condition : Le paramètre 2 est une liste de listes
*/
supprimerKeyListInit(List, Ret):-
    TmpArray = [],
    insertFin([diag1], TmpArray, Array),
    supprimerKeyList(List, Array, Ret).

supprimerKeyList([[_|Value]|List], TmpList, Ret):-
    insertFin(Value, TmpList, TmpRet),
    supprimerKeyList(List, TmpRet, Ret).

supprimerKeyList(_, TmpList, Ret):-
    Ret = TmpList.
