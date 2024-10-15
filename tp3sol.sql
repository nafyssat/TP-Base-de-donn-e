-- 1 Echauffement
-----------------------------------------------------------------------------
--serial entier qui s'incremente automatiquement

-- 1  Observer le remplissage de la table matchs. Pourquoi n’y a-t-il que quatre attributs alors que la table en a cinq ?

-- ajouter un match dans la table matchs 
INSERT INTO matchs VALUES (20,5,1,2,'finale');


-- ajouter un tournois
INSERT INTO tournois VALUES ('Championnat de france',2022,'France');

-- créer une table joueurs ayant comme attributs au moins Nom, Prénom,Date de Naissance, Nationalité.
CREATE TABLE joueurs(
    id serial  PRIMARY KEY,
    nom VARCHAR(30),
    prenom VARCHAR(30),
    dateDeNaissance VARCHAR(10) NOT NULL,
    nationalite VARCHAR(30) NOT NULL
    );

CREATE TABLE joueurequipes (
    jid  INTEGER ,
    eid   INTEGER ,
    PRIMARY KEY(jid,eid),
    FOREIGN  KEY(jid) REFERENCES joueurs(id),
    FOREIGN  KEY(eid) REFERENCES equipes(eid)
);

-- supprimer l’équipe des All Blacks. Que se passe-t-il 
DELETE FROM equipes WHERE nom='All Blacks'; 

-- Modifier les contraintes de la table matchs de sorte que lorsqu’une équipe est supprimée les matchs auxquels elle a participé sont aussi supprimés. Indication : utiliser ALTER TABLE, DROP CONSTRAINT et ADD.
ALTER TABLE matchs DROP CONSTRAINT  matchs_gagnant_fkey ;

ALTER TABLE matchs ADD CONSTRAINT  matchs_gagnant_fkey 
FOREIGN KEY (gagnant) REFERENCES equipes(eid)
ON  DELETE CASCADE;

--perdant 
ALTER TABLE matchs DROP CONSTRAINT  matchs_perdant_fkey ;

ALTER TABLE matchs ADD CONSTRAINT  matchs_perdant_fkey 
FOREIGN KEY (perdant) REFERENCES equipes(eid)
ON  DELETE CASCADE;

-- pour participation 
ALTER TABLE participation DROP CONSTRAINT participation_eid_fkey ;

ALTER TABLE participation ADD CONSTRAINT  participation_eid_fkey 
FOREIGN KEY (eid) REFERENCES equipes(eid)
ON  DELETE CASCADE;

-- autre 
ALTER TABLE joueurequipes DROP CONSTRAINT joueurequipes_eid_fkey ;

ALTER TABLE joueurequipes ADD CONSTRAINT  joueurequipes_eid_fkeyy 
FOREIGN KEY (eid) REFERENCES equipes(eid)
ON  DELETE CASCADE;

ALTER TABLE joueurequipes DROP CONSTRAINT joueurequipes_jid_fkey ;

ALTER TABLE joueurequipes ADD CONSTRAINT  joueurequipes_jid_fkeyy
FOREIGN KEY (jid) REFERENCES joueurs(id)
ON  DELETE CASCADE;

-- supprime joueur italien 
DELETE FROM joueurs WHERE nationalite = 'Italie' ;

-- Supprimer les joueurs ayant joué en Italie. (ne marche pas bien )
DELETE FROM joueurs  WHERE id IN (SELECT id FROM joueurequipes WHERE eid IN ( SELECT eid FROM equipes WHERE pays='Italie') );



