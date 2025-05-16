dir = getDirectory("Select folder with images");
// Crea las carpetas C1, C2 y C3
File.makeDirectory(dir + "C1");
File.makeDirectory(dir + "C2");
File.makeDirectory(dir + "C3");

list = getFileList(dir);

for(i=0; i<list.length; i++){

// Abre la imagen
    open(dir + list[i]);
   
        // Divide los canales
        run("Split Channels");
        
        // Guarda cada canal en la carpeta correspondiente
        selectWindow("C1-" + list[i]);
        saveAs("Tiff", dir + "C1/C1-" + list[i]);
         close();
        
        selectWindow("C2-" + list[i]);
        saveAs("Tiff", dir + "C2/C2-" + list[i]);
         close();
        
        selectWindow("C3-" + list[i]);
        saveAs("Tiff", dir + "C3/C3-" + list[i]);
         close();
        
        // Verifica y cierra cualquier ventana restante
    while (nImages() > 0) {
        close();
    }
}




