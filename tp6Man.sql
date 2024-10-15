--  Nom et annee de la naissance des joueurs ayant participe à Roland Garros en 1994.
SELECT nom, prenom, annaiss 
FROM joueurtennis 
WHERE nujoueur IN 
    (SELECT nujoueur FROM gain 
    WHERE lieutournoi = 'Roland Garros' AND annee = 1994) ; 

-- 2  Nom et nationalite des joueurs ayant participe à la fois au tournoi de Roland Garros et à celui de Wimbledon, en 1992
SELECT nom, nationalite FROM joueurtennis WHERE nujoueur IN 
    (SELECT nujoueur FROM gain WHERE lieutournoi = 'Roland Garros' AND annee = 1992 AND nujoueur IN 
        (SELECT nujoueur FROM gain WHERE lieutournoi = 'Wimbledon' AND annee = 1992) 
    ) ;

-- c  Nom et nationalite des joueurs ayant été sponsorises par Peugeot et ayant gagne à Roland Garros au moins un match (avec un sponsor quelconque).
SELECT nom, nationalite FROM joueurtennis WHERE nujoueur IN 
    (SELECT nujoueur FROM gain WHERE sponsor = 'Peugeot' AND nujoueur IN
        (SELECT DISTINCT nugagnant FROM rencontre WHERE lieuTournoi = 'Roland Garros')
     ) ;

-- d  Numeros des joueurs qui ont toujours perdu à Wimbledon et toujours gagne à Roland Garros.
SELECT nujoueur FROM joueurtennis WHERE nujoueur IN
    (
        (SELECT r1.nuperdant FROM rencontre r1 WHERE r1.lieuTournoi = 'Wimbledon' AND NOT EXISTS 
            (SELECT * FROM rencontre r2 WHERE r2.nugagnant = r1.nuperdant AND r2.lieuTournoi = 'Wimbledon' )
        )
    INTERSECT
        (SELECT r1.nugagnant FROM rencontre r1 WHERE r1.lieuTournoi = 'Roland Garros' AND NOT EXISTS 
            (SELECT * FROM rencontre r2 WHERE r1.nugagnant = r2.nuperdant AND r2.lieuTournoi = 'Roland Garros')
        )
    )
;

-- e  Liste des vainqueurs de tournoi, mentionnant le nom du joueur avec le lieu et l’annee du tournoi qu’il a gagne.
SELECT DISTINCT j.nom, r1.lieuTournoi, r1.annee, j.nationalite FROM joueurtennis j JOIN rencontre r1 ON r1.nugagnant = j.nujoueur 
    AND NOT EXISTS 
        (SELECT * FROM rencontre r2 WHERE r1.lieuTournoi = r2.lieuTournoi AND r1.annee = r2.annee AND r2.nuperdant = r1.nugagnant)  
ORDER by j.nom DESC
; 

-- f Nom des joueurs ayant participe à tous les tournois disputes en 1992.
SELECT j1.nujoueur, j1.nom 
FROM joueurtennis j1 
WHERE NOT EXISTS (
    SELECT DISTINCT g.lieutournoi 
    FROM gain g
    WHERE g.annee = 1992 
    EXCEPT
    SELECT g2.lieutournoi 
    FROM gain g2 
    WHERE g2.annee = 1992 
    AND j1.nujoueur = g2.nujoueur 
);

--  (g) Nombre de rencontres en total
SELECT Count(*) FROM rencontre ; 

-- (h) Liste des tournois et annees avec le nombre de joueurs participants
SELECT lieutournoi, annee, count(nujoueur) as nb_joueurs
FROM gain
GROUP BY lieutournoi, annee
ORDER by annee DESC;

-- (i) Numeros des joueurs ayant eu au moins deux sponsors. 
SELECT nujoueur FROM gain 
GROUP BY nujoueur HAVING count(DISTINCT sponsor) > 1 ;
-- solution 2
SELECT DISTINCT g1.nujoueur 
FROM gain g1 
WHERE EXISTS (
    SELECT * FROM gain g2 
    WHERE g1.nujoueur = g2.nujoueur AND g1.sponsor <> g2.sponsor 
    )
ORDER BY g1.nujoueur ; 

-- (j) Numeros des joueurs ayant eu exactement deux sponsors.
-- Solution with COUNT and HAVING :
SELECT nujoueur FROM gain  
GROUP BY nujoueur  
HAVING COUNT(DISTINCT sponsor) = 2 ;  

SELECT distinct g1.nujoueur FROM gain g1, gain g2
WHERE g1.nujoueur = g2.nujoueur AND g1.sponsor <> g2.sponsor 
AND  NOT EXISTS (
        SELECT * FROM gain g3  
        WHERE g1.nujoueur = g3.nujoueur AND g1.sponsor <> g3.sponsor ANd g3.sponsor <> g2.sponsor
        )
ORDER BY g1.nujoueur ; 


-- (k) Les moyennes des primes gagnees par annee.
SELECT annee, avg(prime) as moyenne_prime FROM gain
GROUP BY annee ;

-- (l) Valeur de la plus forte prime attribuée lors d'un tournoi en 1992, et noms des joueurs qui lont touchee.
SELECT j.nujoueur, j.nom, j.prenom, g.prime as prime_max
FROM joueurtennis j JOIN gain g ON  j.nujoueur = g.nujoueur
WHERE g.annee = 1992 AND g.prime = 
(SELECT max(prime) FROM gain WHERE annee = 1992);

-- (m) Somme gagnée en 1992 par chaque joueur, pour l’ensemble des tournois auxquels il a participé (presentation par ordre de gain decroissant).
