 \! echo Requête <<i>>:
 
 SELECT DISTINCT ville FROM usine ;

  SELECT  nom_prod , couleur FROM produit ;

   SELECT ref_produit  FROM produit WHERE couleur = "rouge" ;

    SELECT  nom_usine  FROM usine JOIN magasin ON  usine.ville= magasin.ville;