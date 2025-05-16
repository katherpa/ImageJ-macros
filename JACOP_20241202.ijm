// Define the directory and file patterns
dir = getDirectory("Select folder with images"); 
patternC1 = "Result of C1-";
patternC2 = "Result of C2-";
output = createFolder(dir, "Results");

// Get the list of files in the directory
list = getFileList(dir);

// Loop through the files and process pairs
for (i = 0; i < list.length; i++) {
    if (startsWith(list[i], patternC1)) {
        // Construct the corresponding C2 filename
        baseName = replace(list[i], patternC1, "");
        baseName = replace(baseName, ".tif", ""); // Remove the .tif extension
        fileC1 = dir + list[i];
        fileC2 = dir + patternC2 + baseName + ".tif";

        // Check if the corresponding C2 file exists
        if (File.exists(fileC2)) {
            // Open the images
            open(fileC1);
            open(fileC2);

            // Run JACoP analysis
            run("JACoP ", "imga=[" + list[i] + "] imgb=[" + patternC2 + baseName + ".tif] thra=1 thrb=1 pearson overlap mm");

            // Save the results from the JACoP results window
            resultFile = output + baseName + ".txt";
            selectWindow("Log");
            saveAs("Text", resultFile);
            run("Close");

            // Close the images
            selectImage(list[i]);
            close();
            selectImage(patternC2 + baseName + ".tif");
            close();
        }
    }
}

//------------------------------
//FUNCTIONS

// Function to create a folder in the working directory
function createFolder(dir, name){
    mydir = dir + name + File.separator;
    File.makeDirectory(mydir);
    if (!File.exists(mydir)) {
        exit("Unable to create the folder");
    }
    return mydir;
}