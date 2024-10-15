-- requetes 1.1 :
-- -- contenu de la table tournois 
SELECT * FROM public.tournois ;
-- -- contenu de la table matchs 
SELECT * FROM public.matchs ;
-- -- contenu de la table equipes 
SELECT * FROM public.equipes ;
-- -- contenu de la table particiation
SELECT * FROM public.participation ;

-- requete 1.2:  l’année des coupes du monde ayant eu lieu en Nouvelle-Zélande ;
SELECT annee FROM public.tournois WHERE pays = 'Nouvelle-Zélande' ;

--requete 1.3 : le nom des pays ayant une équipe s’appelant ‘XV de France’ ;
SELECT pays FROM public.equipes WHERE nom='XV de France';

--requete 1.4 :  le numéro des équipes ayant gagné au moins un match, sans répétitions.
SELECT distinct eid FROM public.equipes join public.matchs ON public.equipes.eid = public.matchs.gagnant ;

-- requete 2.1 :  le nom des équipes ayant gagné au moins un match ;
 SELECT distinct nom FROM public.equipes join public.matchs ON public.equipes.eid = public.matchs.gagnant ;

 -- requete 2.2 : le nom et l’année des tournois dans lesquels l’équipe 2 a perdu un match ;
  SELECT nom , annee FROM public.tournois JOIN public.matchs ON public.tournois.tid = public.matchs.tournois AND perdant = 2 ;

-- requete 2.3 :  le numéro des matchs perdus par les Wallabies ;
 SELECT mid FROM public.matchs JOIN public.equipes ON public.equipes.eid = public.matchs.perdant AND public.equipes.nom = 'Wallabies';

-- requete 2.4 :   le numéro des matchs auxquels ont participé les All Blacks (matchs perdus ou gagnés) ;
SELECT mid FROM public.matchs JOIN public.equipes ON public.equipes.eid = public.matchs.perdant AND public.equipes.nom = 'All Blacks' UNION  SELECT mid FROM public.matchs JOIN public.equipes ON public.equipes.eid = public.matchs.gagnant AND public.equipes.nom = 'All Blacks' ;

-- requetes 2.5 : le numéro des équipes ayant participé à la coupe du monde 1991 ;

SELECT eid FROM participation JOIN tournois ON public.participation.tid = public.tournois.tid AND public.tournois.annee = 1991 ;
-- 2 eme maniere d'ecrire 
SELECT eid FROM participation ,tournois WHERE participation.tid = tournois.tid AND tournois.annee = 1991 ;

-- requete 3.1 :   le nom des équipes ayant participé à la coupe du monde 1991 ;
 SELECT e.nom FROM participation AS p ,tournois AS t,equipes AS e  WHERE p.tid = t.tid AND t.annee = 1991 AND e.eid=p.eid ;

--requete 3.2 : le nom et l’année des tournois dont un match au moins a été perdu par le XV de France ;
SELECT t.nom , t.annee FROM tournois AS t , matchs AS m , equipes AS e WHERE e.nom ='XV de France' AND m.perdant = e.eid AND t.tid=m.tournois ;

-- requetes 3.3 :  le nom des vainqueurs des différentes coupes du monde, année par année ;
SELECT distinct t.annee, e.nom AS vainqueur FROM tournois t JOIN matchs m ON t.tid = m.tournois AND m.tour = 'finale' JOIN equipes e ON m.gagnant = e.eid WHERE t.nom = 'Coupe du Monde';


-- requetes 4.1 : les équipes dont le pays n’a jamais hébergé une coupe du monde ;
SELECT nom ,pays FROM equipes WHERE equipes.pays NOT IN (SELECT DISTINCT tournois.pays FROM tournois WHERE tournois.nom = 'Coupe du Monde' );

-- requetes 4.2 :  le nom des équipes n’ayant jamais participé à une finale ;
SELECT nom FROM equipes WHERE equipes.eid NOT IN (SELECT matchs.gagnant FROM matchs WHERE matchs.tour = 'finale' UNION SELECT matchs.perdant FROM matchs WHERE matchs.tour = 'finale' );

-- requetes 4.3 :   les tournois pendant lequel le ‘XV de France’ a perdu tous ses matchs (évitez d’afficher les tournois où le XV de France n’a pas joué) ;

