// Analyzer Function //
// Lucas Jurgensen //
// Harrison Lab, BTI, Cornell University //

// Excell Code
// Place results in A1 as a column, use code in C1, drag a box width = 3
// =OFFSET($A$1,COLUMNS($A1:A1)-1+(ROWS($1:1)-1)*3,0)

//macro "Jurgen-Analyze Action Tool - TxysscR" {
       
directory = getDirectory("Select a Directory"); 
//f = File.open(""); // display file open dialog

count = 0
for(num=0; num<1000; num++){
	if(num < 10) {
		primary_photo_name = "Series" + "00" + num + "_ch00.tif";
	}
	else if (num < 100) {
		primary_photo_name = "Series" + "0" + num + "_ch00.tif";
	}
	else {
		primary_photo_name = "Series" + num + "_ch00.tif";
	};

	primary_photo = directory + "/" + primary_photo_name;
	
	if(File.exists(primary_photo)){
		analyze(primary_photo);
		primary_photo_nickname = substring(primary_photo_name, 0, lengthOf(primary_photo_name)-9);
		setResult("Plant #", count, primary_photo_nickname);
		count += 1;
	};
};
print("All done!")


function analyze(raw_start_name){
open(raw_start_name);
// Changes File //
// 1. Applys MaxEntropy on the file
// 2. Divides the values in the file by 255
// 3. Creates a new Birghtness/Contrast from 0..1
dir = getDirectory("image"); 
name00 = getTitle;
raw_name00 = dir + name00;

name02 = substring(name00, 0 , lengthOf(name00)-5) + "2.tif";
raw_name02 = dir + name02;
open(raw_name02);
raw_name_m = substring(raw_name02, 0 , lengthOf(raw_name02)-4) + "-m.tif";
name_m = substring(name02, 0 , lengthOf(name02)-4) + "-m.tif";


setAutoThreshold("MaxEntropy dark");
run("Convert to Mask");
run("Divide...", "value=255.000");
run("Enhance Contrast", "saturated=0.35");


// Saves File //
// 1. Finds image's directory and name
// 2. Creates new edited images directory and name
// 3. Saves new image in the same directory

print("Saving mask as: " + name_m);
saveAs("Tiff", raw_name_m);


//////////////////////////
// Compare Mask with 00 //
name00 = name00;
raw_name00 = raw_name00;
open(raw_name00);
imageCalculator("Multiply create", name00, name_m);
run("Threshold...");
run("Measure");
print("Saving 00 result as: " + name00);
saveAs("Tiff", substring(raw_name00, 0 , lengthOf(raw_name00)-4) + "-result.tif");

// Compare Mask with 01 //
name01 = substring(name00, 0 , lengthOf(name00)-5) + "1.tif";
raw_name01 = dir + name01;
open(raw_name01);
imageCalculator("Multiply create", name01, name_m);
run("Threshold...");
run("Measure");
print("Saving 01 result as: " + name01);
saveAs("Tiff", substring(raw_name01, 0 , lengthOf(raw_name01)-4) + "-result.tif");
close();

// Compare Mask with 02 //
open(raw_name02);
imageCalculator("Multiply create", name02, name_m);
run("Threshold...");
run("Measure");
print("Saving 02 result as: " + name02);
saveAs("Tiff", substring(raw_name02, 0 , lengthOf(raw_name02)-4) + "-result.tif");
close();
close();
close();
close();
close();
close();
close();
close("Threshold...");

print("\n");
}

// Neatly Organizes the Data for Easy copy and paste
counter = 0
max_value = getNumber("How Many Data Points are there?", 0) 
max_row = max_value / 3 
while(counter<max_value){
	for(row=0; row < max_row; row++){
		for(column=0; column<3; column++){
			value = getResult("Mean", counter);
			if(column == 0){
				setResult("CC",row,value);
			counter ++;
			}
			if(column == 1){
				setResult("CY",row,value);
			counter ++;
			}
			if(column == 2){
				setResult("YY",row,value);
			counter ++;
			}
		}
	}
}