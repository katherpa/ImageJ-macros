/////////////////////////////////////////////////////////////////////
/* Name: COLOCALIZATION ANALYSIS +	
 * Author: Katherine Herrera
 * Version: 1	Date: 13/05/2023
 * Description: This macro analyses the colocalization and JACoP 

 */ 
/////////////////////////////////////////////////////////////////////

input = getDirectory("Select folder with images");
list = getFileList(input);
output = createFolder(input, "Results");

for(i=0; i<list.length; i++){

//Open file and get data
		path = input + list[i];
		if(endsWith(path, ".tif")) {
		open(path);
		name = File.nameWithoutExtension;

//DUPLICATE AND CHANGE 8-BITS FOR PLUGIN 
		run("Set Scale...", "distance=14.1681 known=1 unit=micron global");
		run("Duplicate...", "duplicate slices=5-15");
		rename("original10"); 
		saveAs("Tiff" , output + name + "_original10" );
		setOption("ScaleConversions", true);
		run("8-bit");
	
// Split Channels
	   run("Split Channels");
				//C1-original10= CD68 ; C2-original10= 3D6 ; C3-original10= Iba-1	
//COLOCALIZATION IN Z-STACKS

	//PHAGOLYSOSOME
		run("Colocalization ", "channel_1=C3-original10 channel_2=C1-original10 ratio=50 threshold_channel_1=50 threshold_channel_2=50 display=255 colocalizated");
		selectWindow("Colocalizated points (8-bit) ");
		rename("phagolysosome");
		run("Z Project...", "projection=[Max Intensity]");
		rename("phagolysosome");
		saveAs("Tiff" , output + name + "_phagolysosome" );
		selectWindow("Colocalizated points (RGB) ");
		saveAs("Tiff" , output + name + "_phagolysosome_color" );  //Z-stack
		close();
		
		//AB inside plaque	
		run("Colocalization ", "channel_1=phagolysosome channel_2=C2-original10 ratio=50 threshold_channel_1=50 threshold_channel_2=50 display=255 colocalizated");
		selectWindow("Colocalizated points (8-bit) ");
		run("Z Project...", "projection=[Max Intensity]");
		rename("AB-phagolysosome");
		saveAs("Tiff" , output + name + "_AB" );
		selectWindow("Colocalizated points (RGB) ");
		saveAs("Tiff" , output + name + "_AB_color" );   //Z-stack
		close();


		//MEASURE AND RESULTS
		selectWindow("C1-original10"); //CD68
		run("Z Project...", "projection=[Max Intensity]");
		run("Measure");
		setAutoThreshold("Moments dark")
		run("Measure"); 	//ASÍ TENEMOS EL DATO DE AREA TOTAL DE LA IMAGEN PORQUE NO SELECCIONAMOS NADA
		close();
		resetThreshold();
		
		selectWindow("C2-original10");
		run("Z Project...", "projection=[Max Intensity]");//3D6
		setAutoThreshold("Otsu dark");
		run("Measure");
		close();
		resetThreshold();
		
		selectWindow("C3-original10");    //Iba-1
		run("Z Project...", "projection=[Max Intensity]")
		setAutoThreshold("Moments dark");
		run("Measure");
		close();
		resetThreshold();
		
		selectWindow( name + "_phagolysosome.tif" );
		setAutoThreshold("Moments dark");
		run("Measure");
				
		selectWindow( name + "_AB.tif" );
		setAutoThreshold("Moments dark");
		run("Measure");		
		
		saveAs("Results",  output + name + ".txt");
			
		//CLOSE WINDOWS
		close("*"); //cierra todas las pestañas
		run("Clear Results");
	}
}
		run("Close All");

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