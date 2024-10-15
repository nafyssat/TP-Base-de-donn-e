-- Nom et ann´ee de la naissance des joueurs ayant particip´e `a Roland Garros en 1994.
SELECT DISTINCT nom , annaiss 
from joueurtennis as j 
join rencontre as r ON j.nujoueur = r.nuperdant OR j.nujoueur = r.nugagnant
Where  r.annee=1994 and r.lieutournoi = 'Roland Garros';

-- Nom et nationalit´e des joueurs ayant particip´e `a la fois au tournoi de Roland Garros et `a celui de Wimbledon,
-- en 1992.
SELECT DISTINCT j.nom, j.nationalite 
FROM  JoueurTennis AS j
JOIN  rencontre  AS r1 ON  j.nujoueur = r1.nuperdant OR j.nujoueur = r1.nugagnant
JOIN rencontre  AS r2 ON  j.nujoueur = r2.nuperdant OR j.nujoueur = r2.nugagnant
WHERE  (r1.lieutournoi = 'Roland Garros' AND r1.annee = 1992) 
  AND   (r2.lieutournoi = 'Wimbledon' AND r2.annee = 1992);


-- Nom et nationalit´e des joueurs ayant ´et´e sponsoris´es par Peugeot et ayant gagn´e `a Roland Garros au moins
-- un match (avec un sponsor quelconque).

SELECT DISTINCT j.nom, j.nationalite 
FROM  JoueurTennis AS j
JOIN  gain AS g ON j.nujoueur = g.nujoueur 
JOIN  rencontre  AS r ON j.nujoueur = r.nugagnant
WHERE  g.sponsor = 'Peugeot' and r.lieutournoi='Roland Garros' ;

--  Num´eros des joueurs qui ont toujours perdu `a Wimbledon et toujours gagn´e `a Roland Garros.
SELECT DISTINCT j.nujoueur 
FROM  JoueurTennis AS j
JOIN  rencontre AS r1 ON j.nujoueur = r1.nugagnant 
JOIN  rencontre  AS r2  ON j.nujoueur = r2.nuperdant 
WHERE  r1.lieutournoi = 'Roland Garros' AND  r2.lieutournoi = 'Wimbledon'
    AND NOT  EXISTS( SELECT * FROM rencontre AS r3 WHERE r3.nuperdant =j.nujoueur  
                     AND r3.lieutournoi = 'Roland Garros') 
    AND NOT EXISTS( SELECT * FROM rencontre AS  r4 WHERE r4.nugagnant =j.nujoueur   
                      AND r4.lieutournoi = 'Wimbledon');

-- (e) Liste des vainqueurs de tournoi, mentionnant le nom du joueur avec le lieu et l’ann´ee du tournoi qu’il a
-- gagn´e.
SELECT DISTINCT j.nom,r1.lieuTournoi,r1.annee 
FROM JoueurTennis AS j 
JOIN rencontre AS r1  ON j.nujoueur = r1.nugagnant 
WHERE  NOT  EXISTS(
      SELECT * FROM rencontre r2 
      WHERE r1.lieuTournoi = r2.lieuTournoi AND r1.annee = r2.annee AND r2.nuperdant = r1.nugagnant )
ORDER BY j.nom DESC;--desc decroissant 

-- (f) Nom des joueurs ayant particip´e `a tous les tournois disput´es en 1992.
SELECT j.nom
FROM joueurtennis j
NATURAL JOIN gain g
WHERE g.annee=1992
GROUP BY j.nom
HAVING COUNT(DISTINCT g.lieuTournoi)=(
    SELECT COUNT(DISTINCT lieuTournoi)
    FROM rencontre
    WHERE annee=1992
);

-- (g) Nombre de rencontres en total.
SELECT COUNT(*)
FROM rencontre;

-- h) Liste des tournois et ann´ees avec le nombre de joueurs participants.
SELECT lieuTournoi,annee,COUNT(DISTINCT j) as nb_joueurs
FROM rencontre as r
JOIN joueurTennis j on j.nujoueur=r.nuperdant OR j.nujoueur=r.nugagnant
GROUP BY  lieuTournoi,annee
ORDER BY annee DESC;

-- (i) Num´eros des joueurs ayant eu au moins deux sponsors. Donnez deux solutions (une avec count et une
-- sans).
SELECT j.nujoueur 
FROM joueurTennis AS j
NATURAL JOIN gain AS g 
GROUP  BY j.nujoueur
HAVING COUNT(distinct g.sponsor)>=2;

--sans count 
-- SELECT DISTINCT g.nujoueur 
-- FROM gain AS g
-- WHERE EXISTS(
--     SELECT * FROM  gain AS g2 
--     WHERE g.nujoueur=g2.nujoueur AND g.sponsor <> g2.sponsor 
-- ) 
-- ORDER BY  g.nujoueur ASC;
SELECT DISTINCT g1.nujoueur
FROM gain AS g1
JOIN gain  AS g2 ON g1.nujoueur = g2.nujoueur 
WHERE g1.sponsor <> g2.sponsor 
ORDER BY   g1.nujoueur ASC;

-- Num´eros des joueurs ayant eu exactement deux sponsors. Donnez deux solutions (une avec count et une
-- sans).

SELECT j.nujoueur 
FROM joueurTennis AS j
NATURAL JOIN gain AS g 
GROUP  BY j.nujoueur
HAVING COUNT(distinct g.sponsor)=2;

SELECT DISTINCT g1.nujoueur
FROM gain AS g1
JOIN gain  AS g2 ON g1.nujoueur = g2.nujoueur 
WHERE g1.sponsor <> g2.sponsor AND 
NOT EXISTS (
    SELECT * 
    FROM gain AS g3
    WHERE g3.nujoueur = g1.nujoueur AND g3.sponsor NOT IN (g1.sponsor, g2.sponsor)
    );

-- (k) Les moyennes des primes gagn´ees par ann´ee.
SELECT  CEILING(AVG(prime)) as moyenne ,annee
FROM gain
GROUP BY annee ;

-- (l) Valeur de la plus forte prime attribu´ee lors d’un tournoi en 1992, et noms des joueurs qui l’ont touch´ee.
SELECT j.nom , g.prime 
FROM  joueurTennis AS j
NATURAL JOIN  gain AS g 
WHERE g.prime IN (
    SELECT MAX(g1.prime) as primeMax
    FROM gain as g1 
    WHERE g1.annee=1992
 )
GROUP BY j.nom,g.prime ;

-- (m) Somme gagn´ee en 1992 par chaque joueur, pour l’ensemble des tournois auxquels il a particip´e (pr´esentation
-- par ordre de gain d´ecroissant).


-- (n) Noms des pays qui ont eu un vainqueur de tournoi chaque ann´ee.
SELECT j.nationalite
FROM joueurtennis j 
WHERE j.nujoueur IN  (
   SELECT r.nugagnant 
   FROM rencontre r 
   WHERE NOT  EXISTS (
            SELECT * FROM rencontre r2 
            WHERE r.lieuTournoi = r2.lieuTournoi AND r.annee = r2.annee AND r2.nuperdant = r.nugagnant )
   )
   AND (
    HAVING  COUNT(j.nujoueur) = (
        SELECT DISTINCT COUNT(annee)
        FROM rencontre
    )
   );
