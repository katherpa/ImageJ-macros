inputDir = getDirectory("Selecciona la carpeta con las imágenes");
outputDir = getDirectory("Selecciona la carpeta para guardar los resultados");
roiDir = getDirectory("Selecciona la carpeta con los archivos ROI");
resultsFile = outputDir + "resultados_totales.txt";

// Crear o limpiar el archivo de resultados
File.saveString("", resultsFile);

list = getFileList(inputDir);

for (i = 0; i < list.length; i++) {
    if (endsWith(list[i], ".tif") && !endsWith(list[i], "_segmentation_MASK.tif")) {
        baseName = replace(list[i], ".tif", "");
        imagePath = inputDir + list[i];
        maskPath = inputDir + baseName + "_segmentation_MASK.tif";
        roiBaseName = replace(baseName, "C2-", ""); // Eliminar el prefijo C1-
        roiPath = roiDir + roiBaseName + ".roi";

        if (File.exists(maskPath)) {
            open(imagePath);
            open(maskPath);
            imageCalculator("Min create", baseName + ".tif", baseName + "_segmentation_MASK.tif");
            resultImageName = "Result of " + baseName + ".tif";
            selectImage(resultImageName);
            run("Tile");
            selectImage(baseName + "_segmentation_MASK.tif");
            selectImage(resultImageName);

            if (File.exists(roiPath)) {
                open(roiPath);
                roiManager("Add");
                //run("Measure");

                setAutoThreshold("Default no-reset");
                setThreshold(1, 65535, "raw");
                run("Measure");

                // Guardar los resultados en el archivo de resultados totales
                saveAs("Results", resultsFile);
                saveAs("Tiff", outputDir + resultImageName); // Guardar la imagen resultante
            } else {
                print("ROI file not found: " + roiPath);
            }


			waitForUser("Revisa los resultados y haz clic en OK para continuar.");

            run("Close All");
        } else {
            print("Mask file not found: " + maskPath);
        }
    }
}
