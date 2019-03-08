program Programme;
{$UNITPATH \SDL2}
//BUT: Affiche un sprite d'helicoptere anime a la position de la souris, ainsi qu'une image bitmap
//ENTREE: La position de la souris et la touche échap
//SORTIE: La position de l'helicoptere

uses SDL2, SDL2_image;


{
  --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------------------VARIABLES ET CONSTANTES-----------------------------------------------------------------------------
  --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
}

const
  //Constantes dediees a la fenetre
  FenetreLongueur=1024;           //La Longueur de la Fenetre
  FenetreHauteur=576;             //La Hauteur de la Fenetre

  //Constantes dediees a l'affichage de l'helicoptere
  HelicoLongueur=128;             //La Longueur du Sprite d'helicoptere
  HelicoHauteur=55;               //La Hauteur du Sprite d'helicoptere
  NbFrames=5;                     //Le Nombre de frames que comporte l'animation de l'helicoptere

  //Constantes dediees a l'affichage du Rider
  RiderLongueur=123;               //La Longueur du BITMAP du Rider
  RiderHauteur=87;                 //La Hauteur du BITMAP du Rider

var
  //Variable dediee a la fenetre
  Fenetre1: PSDL_Window;          //La fenetre du jeu
  Renderer: PSDL_Renderer;        //Le Renderer associe a la fenetre1
  
  //Variables dediees a l'affichage de l'helicoptere
  Helicoptere: PSDL_Texture;      //Ensemble des frames de l'animation de l'helicoptere
  FrameHelico: TSDL_Rect;         //Détermine quelle frame est utilisée à un instant T
  SpriteHelico: TSDL_Rect;        //Helicopter animé affiché à l'écran

  //Variables dediees a l'affichage du Rider
  SurfaceRider: PSDL_Surface;     //Image du Rider chargée
  Rider: PSDL_Texture;            //Image du Rider à afficher
  SpriteRider: TSDL_Rect;         //Image du Rider affichée à l'écran

  //Variables associees a la primitive
  x1,x2,y1,y2:INTEGER;            //Coordonnees de la primitive
  rouge,vert,bleu:INTEGER;         //Couleur de la primitive

  //Variables associees aux touches a la condition de sortie du jeu
  Evenement: PSDL_Event;
  ConditSortie: BOOLEAN;

  

  //Variable pour parcourir la boucle POUR...FAIRE
  i: INTEGER;

BEGIN


{
  --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------------------INITIALISATION--------------------------------------------------------------------------------------
  --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
}


//----------------INITIALISATION DU SYSTEME ET DE LA FENETRE----------------------------------------------------------------------------------------------------------------------------------------
 
  //Initialisation de l'aleatoire
  randomize;

  //Initialisation du Systeme Vidéo
  IF SDL_Init(SDL_INIT_VIDEO) < 0 THEN Halt;

  //Création de la Fenêtre et du Renderer
  Fenetre1 := SDL_CreateWindow ('Fenetre de jeu', 250, 250, FenetreLongueur, FenetreHauteur, SDL_WINDOW_SHOWN); //Création et affichage d'une fenêtre de 500x500 px à l'emplacement 250, 250 sur l'écran
  IF Fenetre1 = nil THEN HALT;

  //Création du renderer de l'helicoptere et association de ce dernier à la fenetre "Fenetre1"
  Renderer := SDL_CreateRenderer(Fenetre1, -1, 0);
  IF Renderer = nil THEN Halt;


//----------------INITIALISATION DE L'HELICOPTERE---------------------------------------------------------------------------------------------------------------------------------------------------

  //Initialisation du Tileset de l'helicoptere
  Helicoptere := IMG_LoadTexture(Renderer,'..\Assets\helicopter.png');
  IF Helicoptere = nil THEN Halt;

  //Initialisation de l'animation
  FrameHelico.x := 0;
  FrameHelico.y := 0;
  FrameHelico.w := HelicoLongueur;
  FrameHelico.h := HelicoHauteur;

  //Initialisation du Sprite
  SpriteHelico.w := HelicoLongueur;
  SpriteHelico.h := HelicoHauteur;


//----------------INITIALISATION DU RIDER-----------------------------------------------------------------------------------------------------------------------------------------------------------

  //Chargement du fichier image BITMAP
  SurfaceRider := SDL_LoadBMP('..\Assets\rider.bmp');
  IF SurfaceRider = nil THEN Halt;

  //Initialisation de l'image du Rider
  Rider := SDL_CreateTextureFromSurface(Renderer, SurfaceRider);
  IF Rider = nil THEN Halt;

  //Initialisation de la position du Rider
  SpriteRider.x := 100;
  SpriteRider.y := 85;
  SpriteRider.w := RiderLongueur;
  SpriteRider.h := RiderHauteur;


//----------------INITIALISATION DE LA CONDITION DE SORTIE------------------------------------------------------------------------------------------------------------------------------------------

  new(Evenement);
  ConditSortie := FALSE;




{
  --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------------------BOUCLE DE JEU---------------------------------------------------------------------------------------
  --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
}


  WHILE ConditSortie=FALSE DO
  BEGIN
    FOR i := 0 TO NbFrames-1 DO
    BEGIN
      
//----------------GESTION DE L'IMAGE DU RIDER-------------------------------------------------------------------------------------------------------------------------------------------------------

      //On dessine l'image du Rider
      SDL_RenderCopy(Renderer, Rider, nil, @SpriteRider);


//----------------GESTION DU SPRITE DE L'HELICOPTERE ET DE LA CONDITION DE SORTIE-------------------------------------------------------------------------------------------------------------------

      WHILE SDL_PollEvent ( Evenement ) = 1 DO //Tant que l'évènement attendu n'est pas réalisé
      BEGIN

        //On verifie si la souris est toujours sur la fenetre
        IF (Evenement^.motion.x > 0) AND (Evenement^.motion.x < FenetreLongueur) AND (Evenement^.motion.y > 0) AND (Evenement^.motion.y < FenetreHauteur) THEN
        BEGIN
          SpriteHelico.x := Evenement^.motion.x - (HelicoLongueur div 2); //On positionne le Sprite de l'Helicoptere a la position x de la souris
          SpriteHelico.y := Evenement^.motion.y - (HelicoHauteur div 2);  //On positionne le Sprite de l'Helicoptere a la position y de la souris
        END;

        //On verifie si la touche Echap est pressee
        IF ( Evenement^.key.keysym.sym = SDLK_ESCAPE ) THEN
        BEGIN
          ConditSortie := TRUE;
        END;
      END;

      //On change la frame du sprite de l'helicoptere
      FrameHelico.x := HelicoLongueur * i;
      
      //On dessine le Sprite de l'helicoptere
      SDL_RenderCopy(Renderer, Helicoptere, @FrameHelico, @SpriteHelico);


//----------------GESTION DE LA PRIMITIVE-----------------------------------------------------------------------------------------------------------------------------------------------------------

      //On tire au hasard les coordonnees et la couleur de la primitive
      x1:=random(FenetreLongueur);
      x2:=random(FenetreLongueur);
      y1:=random(FenetreHauteur);
      y2:=random(FenetreHauteur);
      rouge:=random(255);
      vert:=random(255);
      bleu:=random(255);

      //On set la couleur pour dessiner la primitive selon les valeurs tirees au hasard
      SDL_SetRenderDrawColor(Renderer,rouge,vert,bleu,255);

      //On dessine la primitive selon les coordonnees tirees au hasard
      SDL_RenderDrawLine(Renderer,x1,y1,x2,y2);


//----------------AFFICHAGE DU RENDERER-------------------------------------------------------------------------------------------------------------------------------------------------------------

      //On affiche le renderer
      SDL_RenderPresent(Renderer);

      //On reinitialise le renderer
      SDL_SetRenderDrawColor(Renderer,0,0,0,SDL_ALPHA_OPAQUE);
      SDL_RenderClear(Renderer);

      //On attend 20ms avant d'afficher la prochaine frame
      SDL_Delay(20);
    END;
  END;




{
  --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------------------ARRET DU PROGRAMME----------------------------------------------------------------------------------
  --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
}


//----------------DESTRUCTION DES SPRITES ET IMAGES-------------------------------------------------------------------------------------------------------------------------------------------------

  //Destruction du tileset et du renderer de l'helicoptere
  SDL_DestroyTexture(Helicoptere);

  //Destruction de l'image du Rider
  SDL_FreeSurface(SurfaceRider);
  SDL_DestroyTexture(Rider);

  //Destruction de la fenetre de jeu
  dispose(Evenement);
  SDL_DestroyRenderer(Renderer);
  SDL_DestroyWindow (Fenetre1);

  //Fermeture du systeme
  SDL_Quit;

END.