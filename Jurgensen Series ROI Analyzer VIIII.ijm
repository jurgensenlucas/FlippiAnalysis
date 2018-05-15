// Jurgen-Image Analyzer //
// Lucas Jurgensen //
// Harrison Lab, BTI, Cornell University //


directory = getDirectory("Select a directory"); 
roi_num = getNumber("How many ROI's would you like to use?", 0);
count = 0;
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
		roiAnalyze(primary_photo, roi_num);
		primary_photo_nickname = substring(primary_photo_name, 0, lengthOf(primary_photo_name)-9);
		for(name_num = 0; name_num < roi_num; name_num +=1){
			setResult("Plant #", count + name_num, primary_photo_nickname);
		}
		count += roi_num;
		
	};
};
print("All done!");

function roiAnalyze(name00, roi_num){
	roi_num = roi_num;
	open(name00);
	roiManager("reset");
	selection_num = 0;
	// Runs though the number of times that the user selected earlier
	while(selection_num < roi_num){
		waitForUser("Waiting", "Select Oval for ROI");
		// Waits for user to make selection, then click 'ok'
		//run("ROI Mangaer...")
		roiManager("Add");
	selection_num += 1;
	}
	// Measures for the original image (Image00)
	roiManager("measure");

	// Measures for second image (Image01)
	name01 = substring(name00, 0 , lengthOf(name00)-5) + "1.tif";
	open(name01);
	roiManager("measure");
	
	// Measures for the third image (Image 02)
	name02 = substring(name00, 0 , lengthOf(name00)-5) + "2.tif";
	open(name02);
	roiManager("measure");
	close();
	close();
	close();

	print("Image ROI Analyzer");
	print("Worked on image: " + name00);
	print(" ");

}

// Neatly Organizes the Data for Easy copy and paste

spot = 0
max_value = getNumber("How Many Data Points are there?", 0) 
max_row = max_value / 3
while(spot < max_value){
	for(row = 0; row < max_row; row += roi_num){
		roi = 1;
		while(roi <= roi_num){
			setResult("ROI",row + roi - 1, roi);
			roi += 1;
			}
		for(column=0; column<3; column++){
			
			if(column == 0){
				count = 0;
				while(count < roi_num){
				value = getResult("Mean", spot + count);
				setResult("CC",row + count, value);
				count += 1;
			}
			}
			
			if(column == 1){
				count = 0;
				while(count < roi_num){
				value = getResult("Mean", spot + count);
				setResult("CY",row + count, value);
				count += 1;
			}
			}
			
			if(column == 2){
				count = 0;
				while(count < roi_num){
				value = getResult("Mean", spot + count);
				setResult("YY",row + count, value);
				count += 1;
			}
			print("passed");
			}
			spot += roi_num;
		}
	}
}
