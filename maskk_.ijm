///////////////////////////////////////////////////////////////////////////////////////////////////////////
	/*
	 UNIVERSITY OF BARCELONA
	 Facultat de Biologia
	 Departament de Biologia Cel·lular, Fisiologia i Immunologia.
	 Edifici Prevosti, planta 1, Lab 1
	 Barcelona 08036 
  
  ------------------------------------------------
  Katherine T. Herrera Panchi (kherrera@ub.edu) 
  ------------------------------------------------
 
	Name of Macro: 3_Maskto16b.ijm
  
	 Date: 19/11/2024
 	Version: ImageJ 1.54p
  
	*/
	
///    Explicación: A partir de la máscara generada de LABKIT (0-1) se pasa a 0-255 (8 bits) y luego se hace un multiply de 257 para pasarlo a 16 bits y 
/// poder luego hacer el image calculator con las dos imágenes. La original y la máscara.
  
/////////////////////////////////////////////////////////////////////////////////////////////////////////////


input = getDirectory("Select folder with images");
list = getFileList(input);
output = createFolder(input, "MASKS");

for(i=0; i<list.length; i++){

//Open file and get data
	path = input + list[i];
	if(endsWith(path, ".tif")) {
	open(path);
		//imageTitle = getTitle();
		name = File.nameWithoutExtension;

setAutoThreshold("Default dark no-reset");
run("Threshold...");
setThreshold(1, 255);
setOption("BlackBackground", false);
run("Convert to Mask");
run("16-bit");
run("Multiply...", "value=257");
saveAs("Tiff" , output + name + "_MASK");
		
		//CLOSE WINDOWS
		close("*"); //cierra todas las pestañas

	}
}

//------------------------------
//FUNCTIONS

//Function to create a folder in the working directory
function createFolder(dir, name){
	mydir = dir+name+File.separator;
	File.makeDirectory(mydir);
	if(!File.exists(mydir)){
		exit("Unable to create the folder");
	}
	return mydir;
}