import java.io.IOException;
import java.io.File;

import MG2D.geometrie.Texture;
import MG2D.geometrie.Point;

public class Pointeur {
    private int value;
    private Texture triangleGauche;
    private Texture triangleDroite;
    private Texture rectangleCentre;

    public Pointeur(){
	this.triangleGauche = new Texture("img/star.png", new Point(30, 492), 40,40);
	this.triangleDroite = new Texture("img/star.png", new Point(530, 492), 40,40);
	this.rectangleCentre = new Texture("img/select2.png", new Point(80, 460), 440, 100);
	this.value = Graphique.tableau.length-1;
    }

    public void lancerJeu(ClavierBorneArcade clavier){
	if(clavier.getBoutonJ1ATape()){
	    String script = "./"+Graphique.tableau[getValue()].getNom()+".sh";
	    Graphique.stopMusiqueFond();
	    try {
		File scriptFile = new File(script);
		if(!scriptFile.exists()){
		    System.err.println("Script introuvable : "+script);
		    return;
		}
		ProcessBuilder pb = new ProcessBuilder("bash", script);
		pb.directory(new File("."));
		Process process = pb.start();
		process.waitFor(); // attend la fin du jeu avant de revenir au menu
	    } catch (IOException e) {
		System.err.println("Impossible de lancer le script du jeu : "+script);
		e.printStackTrace();
	    } catch(InterruptedException e){
		Thread.currentThread().interrupt();
		System.err.println("Lancement du jeu interrompu : "+script);
	    } finally {
		Graphique.lectureMusiqueFond();
	    }
	}
    }

    public int getValue() {
	return value;
    }

    public void setValue(int value) {
	this.value = value;
    }

    public Texture getTriangleGauche() {
	return triangleGauche;
    }

    public void setTriangleGauche(Texture triangleGauche) {
	this.triangleGauche = triangleGauche;
    }

    public Texture getTriangleDroite() {
	return triangleDroite;
    }

    public void setTriangleDroite(Texture triangleDroite) {
	this.triangleDroite = triangleDroite;
    }

    public Texture getRectangleCentre() {
	return rectangleCentre;
    }

    public void setRectangleCentre(Texture rectangleCentre) {
	this.rectangleCentre = rectangleCentre;
    }

}
