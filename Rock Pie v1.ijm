//***********************************************************************
//"Rock pie" by Adrian Hornby
//Component analysis for high-magnification SEM images

//The macro segments and measures the area fraction of background, target components,
//and non-target components in a greyscale SEM image, and finally measures
//the size and shape of the target components on a single-particle basis.
//Output files are saved in a folder using the original image file name as title.
//MorphoLibJ, Shape Filter, Non-local means denoising and Beat (xlib) plugins are required.
//See Readme for instructions etc.

//A standalone macro for component fractions and size and shape calculations is provided,
//as well as a macro using the Read and Write Excel plugin for easy data crunching.

//The macro is expanded from the surface salts segmentation macro described here
//Casas, Hornby, Cimarelli and Dingwell 2021 - "A novel method for the quantitative
//morphometric characterization of soluble salts on volcanic ash - 
//submitted to Bulletin of Volcanology"
//***********************************************************************

macro "Rock pie macro" {	
//***********************************************************************
//Functions
//***********************************************************************
	
//reduce noise and set the  threshold for surface particles
	function manualthreshold() { 
		Dialog.create("Non-linear means denoising");
		Dialog.addCheckbox("Run non-linear means denoising?", 1);
		Dialog.addMessage("...not recommended for images with poor greyscale contrast between components");
		Dialog.show();
		nlmd=Dialog.getCheckbox();
		selectImage(cropped);
		cropped=getTitle();
		if (nlmd==1)
			run("Non-local Means Denoising", "sigma=15 smoothing_factor=1 auto");	
		run("Duplicate...", " ");
		particles1=getImageID();
			
		gThr="Set a global threshold for **"+tc+" and "+ntc+"**?";
		dThr="Set light and dark thresholds for **"+contrC+"**?";
		tThr="Set a separate threshold for **"+contrC+"**?";
		itemsT=newArray(gThr, tThr, dThr);	
		if (thrch=="shades of grey?") 
			ThrOp=tThr; 
		if (thrch=="size?")
			ThrOp=gThr;
		if (thrch=="size & shade?") {	
			Dialog.create("Threshold options");
			itemsT=newArray(gThr, tThr, dThr);
			Dialog.addChoice("threshold options", itemsT, gThr);
			Dialog.show();
			ThrOp=Dialog.getChoice();
		}
		
		run("Add Image...", "image=[cropped] x=0 y=0 opacity=70");
		if (ThrOp==dThr) {
			run("Threshold...");
			waitForUser("Set dark threshold", "so that all pixels **darker** than the background are black...\n...then click \"Apply\"");
			//run("Convert to Mask");
			run("Close");
			selectImage(cropped);
			run("Duplicate...", " ");
			particles2=getImageID();
			run("Add Image...", "image=[cropped] x=0 y=0 opacity=70");
			run("Threshold...");
			waitForUser("Set light threshold", "so that all pixels **lighter** than the background are white...\n...then click \"Apply\"");
			run("Close");
			//run("Convert to Mask");
			//setThreshold(255, 255);
			imageCalculator("Add create", particles1, particles2);
			rename("globalThr");
			//selectWindow("contrThr");
			selectImage(particles1);
			close();
			selectImage(particles2);
			close();
			
		}

		else if (ThrOp==tThr) {
			run("Threshold...");
			waitForUser("Set threshold", "so that **"+contrC+"** pixels are white and other pixels are black...\n...then click \"Apply\"");
			///run("Convert to Mask");
			run("Close");
			rename("contrThr");
			selectImage(cropped);
			run("Duplicate...", " ");
			particles2=getImageID();
			run("Add Image...", "image=[cropped] x=0 y=0 opacity=70");
			run("Threshold...");
			waitForUser("Set global threshold", "so that only **"+bkg+"** pixels are black...\n...then click \"Apply\"");
			//run("Convert to Mask");
			run("Close");
			rename("globalThr");
			//selectWindow("contrThr");
			//selectImage(particles2);
			//close();
		}
		else {
			run("Threshold...");
			waitForUser("Set threshold", "so that all **"+tc+" and "+ntc+"** pixels are white and "+bkg+ " pixels are black...\n...then click \"Apply\"");
			rename("globalThr");
			run("Close");
		}
	}
	
//manual editing of threshold area
	function fillparticles() {
		prefill=getTitle();
		selectImage(cropped);
		cropped=getTitle();
		wait(50);
		selectImage(prefill);
		Overlay.remove;
		if (opac==50)
			run("Add Image...", "image=[cropped] x=0 y=0 opacity=50");
		else 
			run("Add Image...", "image=[cropped] x=0 y=0 opacity=70");
		setForegroundColor(255, 255, 255);
		setTool(19);
		Dialog.create("Define "+particles+"");
		Dialog.addMessage("Hint: Try Process/Binary/Erode-Dilate-Open-Close options (and Edit/Undo) while editing");
		Dialog.addCheckbox("Remove Outliers?", 0);
		Dialog.show();
		if (Dialog.getCheckbox()==1)
			run("Remove Outliers...");
		waitForUser("Use Paintbrush to define "+particles+" (if necessary)..., then press OK");
		Dialog.create("Particles");
		Dialog.addCheckbox("Fill holes?", 0);
		Dialog.addMessage("Warning: this will fill holes throughout the image. \n"+"Use if holes are present only in the "+particles);
		Dialog.addCheckbox("Are all "+particles+" filled?", 0);
		Dialog.show();
		holes=Dialog.getCheckbox();
		filled=Dialog.getCheckbox();
		if (filled==0) {
			if (holes==1) {
				run("Fill Holes");
				Dialog.show();
			}
			fillparticles();	
		}
		else
			if (holes==1) 
				run("Fill Holes");
	}

	function disconnectparticles () {
		Dialog.create("Disconnect particles");
		Dialog.addCheckbox("Separate touching particles?", 1);
		Dialog.addCheckbox("Invert image?", 0)
		Dialog.addNumber("Disconnect level 0-1 (1 = max. disconnects, 0.8 = default)", "0.8");
		Dialog.show();
		dc=Dialog.getCheckbox();
		dcl=Dialog.getNumber();
		if(dc==1) {
			run("Invert");
			run("Disconnect Particles", "disconnection=dcl xsize=1.0000 ysize=1.0000 zsize=1.0000 algorithm=[new algorithm] euler=[  8] sigma=1,1,1 distance=0.5000 holes,=0.0000 particles,=0.0000 separate");
			wait(1000);
			selectWindow("labeled");
			setAutoThreshold("Default dark");
			setOption("ScaleConversions", true);
			run("8-bit");
			setAutoThreshold("Default dark");
			run("Threshold...");
			setThreshold(1, 255);
			setOption("BlackBackground", true);
			run("Convert to Mask");
			run("Close");
			run("Set Scale...", "distance="+scaleL+" known="+scale+" pixel=1 unit=um");
			Dialog.create("Disconnect check");
			Dialog.addCheckbox("Accept particle separation? (leave unticked to change disconnection level)", 0);
			Dialog.show();
			adc=Dialog.getCheckbox();
			if (adc==0) {
				close();
				disconnectparticles();
			}
		disconnected=getTitle();
		run("Invert");
		saveAs(path4)	
		}
	}	

//size, shape and area fraction calculation
//also provided as a standalone macro "Rock Pie calc" that will run on a folder of images
//produced by Rock Pie.
	function comp_measurements() {

		run("Clear Results");
		open(path7);
		croparea=getImageID();
		selectImage(croparea);
		run("Make Binary");
		run("Measure");
		imagearea=getValue("Area");
		print("image area = " + imagearea);
		run("Clear Results");
		open(path3);
		ntcimage=getImageID();
		//run("Invert");
		Overlay.remove;
		run("Make Binary");
		wait(50);
		run("Analyze Particles...", "size=5-Infinity pixel display");
		sumxA=0;
		for (k=0; k<nResults; k++) {
			sumxA=sumxA+getResult("Area", k);
		}
		ntcarea=sumxA;
		print(ntc+" area = " + ntcarea);
		ntcpercent=((ntcarea/imagearea)*100);
		print (ntc+" coverage (%) = " + ntcpercent);
		run("Clear Results");
		open(path4);
		tcimage=getImageID();
		run("Make Binary");
		wait(50);
		run("Analyze Particles...", "size=5-Infinity pixel display");
		sumsA=0;
		for (k=0; k<nResults; k++) {
			sumsA=sumsA+getResult("Area", k);
		}
		tcs=sumsA;
		print (tc+" area = " + tcs);
		tcpercentT=((tcs/imagearea)*100);
		print ("Total "+tc+" coverage (%) = " + tcpercentT);
		open(path2);
		run("Make Binary");
		wait(50);
		run("Clear Results");
		run("Analyze Particles...", "size=5-Infinity pixel display");
		sumsA=0;
		for (k=0; k<nResults; k++) {
			sumsA=sumsA+getResult("Area", k);
		}
		bkgarea=sumsA;
		print (bkg+"area = " + bkgarea);
		bkgpercent=((bkgarea/imagearea)*100);
		print ("Total "+bkg+" coverage (%) = "+ bkgpercent);
		run("Clear Results");
		selectWindow("-"+tc+".tif");
		run("Make Binary");
		//run("Invert"); //***************************************************************************
		Dialog.create("Edges");
		Dialog.addCheckbox("Exclude "+tc+" on edges from single-particle measurements?", 1);
		Dialog.show();
		run("Invert");
		if (Dialog.getCheckbox()==1)
			run("Shape Filter", "area=0-Infinity area_convex_hull=0-Infinity perimeter=0-Infinity perimeter_convex_hull=0-Infinity feret_diameter=0-Infinity min._feret_diameter=0-Infinity max._inscr._circle_diameter=0-Infinity area_eq._circle_diameter=0-Infinity long_side_min._bounding_rect.=0-Infinity short_side_min._bounding_rect.=0-Infinity aspect_ratio=1-Infinity area_to_perimeter_ratio=0-Infinity circularity=0-Infinity elongation=0-1 convexity=0-1 solidity=0-1 num._of_holes=0-Infinity thinnes_ratio=0-1 contour_temperatur=0-1 orientation=0-180 fractal_box_dimension=0-2 option->box-sizes=2,3,4,6,8,12,16,32,64 add_to_manager draw_holes black_background fill_results_table exclude_on_edges");
		else
			run("Shape Filter", "area=0-Infinity area_convex_hull=0-Infinity perimeter=0-Infinity perimeter_convex_hull=0-Infinity feret_diameter=0-Infinity min._feret_diameter=0-Infinity max._inscr._circle_diameter=0-Infinity area_eq._circle_diameter=0-Infinity long_side_min._bounding_rect.=0-Infinity short_side_min._bounding_rect.=0-Infinity aspect_ratio=1-Infinity area_to_perimeter_ratio=0-Infinity circularity=0-Infinity elongation=0-1 convexity=0-1 solidity=0-1 num._of_holes=0-Infinity thinnes_ratio=0-1 contour_temperatur=0-1 orientation=0-180 fractal_box_dimension=0-2 option->box-sizes=2,3,4,6,8,12,16,32,64 add_to_manager draw_holes black_background fill_results_table");
		
		n = nResults;
		area1 = newArray(n); 
		length1 = newArray(n); 
		area2 = newArray(n); 
		length2 = newArray(n);
		ff1 = newArray(n);
		feret1 = newArray(n); 
		minferet1 = newArray(n);
		orientation1 = newArray(n);
		roiLabel1 = newArray(n);
		
		for (j = 0; j<n; j++) {
			orientation1[j] = getResult('Orientation', j); 
			length1[j] = getResult('Peri.', j);
			area1[j] = getResult('Area', j);
			area2[j] = getResult('Area Conv. Hull', j);
			length2[j] = getResult('Peri. Conv. Hull', j);
			ff1[j] = getResult('Thinnes Rt.', j);
			feret1[j] = getResult('Feret', j);
			minferet1[j] = getResult('Min. Feret', j);
		}
		
		run("Clear Results"); 
		for (j = 0; j<n; j++) { 
			setResult("Area", j, area1[j]);
			setResult("Perim.", j, length1[j]); 
			setResult("CH-Area", j, area2[j]); 
			setResult("CH-Perim.", j, length2[j]); 
			setResult("Solidity", j, area1[j]/area2[j]); 
			setResult("Convexity", j, length2[j]/length1[j]); 
			setResult("FormFactor", j, ff1[j]);
			setResult("Circularity", j, length1[j]/(2*sqrt(PI*area1[j])));
			setResult("Roundness", j, 4*area1[j]/(PI*pow(feret1[j],2)));
			setResult("AR-feret", j, minferet1[j]/feret1[j]);
			setResult("Feret-d", j, feret1[j]); 
			setResult("MinFeret-d", j, minferet1[j]);
			setResult("Orientation", j, orientation1[j]);
		} 
			
		updateResults();
		selectWindow("Results");
		saveAs("results", path5);
		run("Summarize");
		headings = split(String.getResultsHeadings);
		print(String.getResultsHeadings);
		for (b = nResults-4; b<nResults; b++) {
			row=b;
			line=" ";
			for (a=0; a<lengthOf(headings); a++)
				line = line + getResultString(headings[a],row) + " ";
			print(line);
		}
		print(" ");
		print ("Mean");
		print("s.d.");
		print("min");
		print("max");
		selectWindow("Log");
		save(path6);
	}
	
//****************************************************************
//End of functions
//****************************************************************

	
//clear, reset and open images
//**************************************
	run("Clear Results"); 
	if (nImages>0) 
		close("*");
	print("\\Clear");
	setOption("BlackBackground", true);
	setOption("DebugMode", false);
	
	Dialog.create("Define components and run type");
	Dialog.addString("Target component:", "crystals");
	Dialog.addString("Non-target component:", "glass");
	Dialog.addString("Background component:", "voids");
	Dialog.addCheckbox("Batch process a set of images in a folder?", 0);
	Dialog.addMessage("Leave unchecked to run on a single image");
	Dialog.show();
	runtype=Dialog.getCheckbox();
	if (runtype==1) {
		input=getDirectory("Choose parent directory");
		output=getDirectory("Choose or create output directory");
		list=getFileList(input);
		Array.print(list);
	}
	else { input=File.openDialog("Choose image to be processed");
		output=getDirectory("Choose or create output directory");
		list=newArray(input);
	}
	tc=Dialog.getString();
	ntc=Dialog.getString();
	bkg=Dialog.getString();
	
	for (i = 0; i < list.length; i++) {
		if (runtype==0) 
			open(input);
		else { dirName = list[i];
			dir=input+File.separator+dirName;
			if (endsWith(list[i], "/"))
				continue
			if (endsWith(list[i], ".txt"))
				continue
			open(dir);
		}
		
		
		sampleName=File.nameWithoutExtension;
		savedir=output+File.separator+sampleName;
		orig=getTitle();
		File.makeDirectory(savedir)
		path1=savedir+File.separator+"-crop.tif";
		path2=savedir+File.separator+"-"+bkg+".tif";
		path3=savedir+File.separator+"-"+ntc+".tif";
		path4=savedir+File.separator+"-"+tc+".tif";
		path5=savedir+File.separator+"-results.csv";
		path6=savedir+File.separator+"-fractions.txt";
		path7=savedir+File.separator+"-croparea.tif";

		
//scale, crop and threshold image
//**************************************	
		setTool("line");
		Dialog.create("Scale and image adjustment")
		Dialog.addMessage("Enter length of scale bar (numbers only)");
		Dialog.addNumber("scale bar length", 10);
		Dialog.show();
		scale=Dialog.getNumber();

		waitForUser("Measure scale... then press OK");
		getLine(x1, y1, x2, y2, lineWidth);
		scaleL=x2-x1;
		run("Set Scale...", "known="+scale+" pixel=1 unit=um");
		Dialog.create("Image adjustments");
		Dialog.addCheckbox("Adjust brightness and contrast?", 1);
		Dialog.addCheckbox("Run Bandpass filter?", 0);
		Dialog.addCheckbox("Subtract background? - for uneven background/lighting", 0);
		Dialog.show();
		bandc=Dialog.getCheckbox();
		bandp=Dialog.getCheckbox();
		rbfilt=Dialog.getCheckbox();
		if (bandc==1) {
			run("Window/Level...");
			waitForUser("Set brightness and contrast... then click 'Apply (don't worry if it appears to reset)");
			run("Apply LUT");
			if (isOpen("W&L")) {
				selectWindow("W&L");
				run("Close");
			}
		}
		if (rbfilt==1) {
			run("Subtract Background...");
			//waitForUser("Select options, apply filter then press OK");
		}
		setTool("rectangle");
		run("Duplicate...", " ");
		bandpass=getImageID();
		waitForUser("Select area to measure (or crop out scale text)... then press OK");	
		if (bandp==1) {
			run("Bandpass Filter...", "filter_large=50 filter_small=2 suppress=None tolerance=5 autoscale saturate");
			Dialog.create("Use FFT bandpass?");
			items = newArray("Yes (with default settings, as shown)", "Yes (but with manual settings)", "No");
			Dialog.addRadioButtonGroup("Use bandpass (previewed in selection)?", items, 3, 1, "Yes (with default settings, as shown)");
			Dialog.addMessage("If black voids become too light choose either \"No\" or choose manual settings \n"+"and filter structures down to a higher pixel value. \n"+"Suggested setting is 150 pixels.");
			Dialog.show();
			fft=Dialog.getRadioButton();
			if (fft=="Yes (with default settings, as shown)") {
				run("Crop");
			}
			if (fft=="Yes (but with manual settings)") {
				roiManager("add");
				close();
				selectWindow(orig);
				roiManager("Select", 0);
				run("Bandpass Filter...");
				run("Crop");
			}
			if (fft=="No") {
				roiManager("add");
				close();
				selectWindow(orig);
				roiManager("Select", 0);
				run("Crop");
			}
		}


		else
			run("Crop");	
		roiManager("reset");
		save(path1);
		run("Duplicate...", " ");
		run("8-bit");
		rename("cropped");
		run("Duplicate...", " ");
		setForegroundColor(0, 0, 0);
		run("Select All");
		run("Fill");
		croparea=getImageID();
		save(path7);
		close();
		close(orig);
		close(bandpass);
		selectWindow("cropped");
		cropped=getImageID();

//roughly define size difference between tcs and ntcs
//**************************************
		topts=newArray("shades of grey?","size?","size & shade?");
		Dialog.create("Threshold type?");
		Dialog.addChoice("Are non-"+bkg+" components mainly distinguished by", topts) 
		Dialog.addMessage("Select \"size\" if image contains "+tc+" with little overlap in \n"
		+"size distribution to "+ntc);
		Dialog.show();
		thrch=Dialog.getChoice();

		if (thrch!="shades of grey?") {
			Dialog.create("Size choice");
			Dialog.addCheckbox("Select if "+ntc+" are larger than "+tc+" components", 0);
			Dialog.addMessage("Leave unchecked if "+tc+" are larger");
			Dialog.show();
			bigntc=Dialog.getCheckbox();
			
			run("Duplicate...", " ");
			run("Select None");
			setTool("freehand");
			if (bigntc==1) {
				bigpart=ntc;
				waitForUser("Outline smallest "+bigpart+" particle");
				minPsize=getValue("Area");
				close();
			}
			else {
				bigpart=tc;
				waitForUser("Outline smallest "+bigpart+" particle");
				minPsize=getValue("Area");
				close();
			}
			if (thrch=="size?")
			contrC=bigpart;
		}

		if (thrch!="size?") {
			dcomp=newArray(tc, ntc);
			Dialog.create("Contrasting component")
			Dialog.addChoice("Choose component with highest contrast to "+bkg, dcomp, tc)
			Dialog.show();
			contrC=Dialog.getChoice();
			if (thrch=="shades of grey?") {
				minPsize=0;
				bigpart=tc;
			}
		}

//thresholding
//**************************************
		manualthreshold();
		
		Dialog.create("Filters");
		Dialog.addCheckbox("Run morphological filters", 1);
		Dialog.addMessage("Morphological filters smooth the boundaries of thresholded objects");
		Dialog.show();
		filters=Dialog.getCheckbox();
		
		opac=70;
		if (filters==1)
			run("Morphological Filters", "operation=Opening element=Diamond radius=1");
		else
			run("Duplicate...", " ");
			
		//run("Median...", "radius=2");
		particles=tc+" and "+ntc;
		fillparticles();
		run("Invert");
		run("Remove Overlay");
		save(path2);
		close();

		if (bigpart==contrC)
			minPcontSize=minPsize/1.5;
		else
			minPcontSize=minPsize*1.5;
	
		if (isOpen("contrThr")) {
			selectWindow("contrThr");
			if (filters==1) 
					run("Morphological Filters", "operation=Opening element=Diamond radius=1");
			else 
				run("Duplicate...", " ");
			//run("Median...", "radius=2");
			run("Make Binary");
			run("Analyze Particles...", "size=minPcontSize-Infinity show=Masks");
			run("Invert");
			
			particles=contrC;
			//run("Invert");
			fillparticles();
			rename("contrThr2");
			if (contrC==tc)
				saveAs(path4);
			else
				saveAs(path3);
		}
		else {
			selectWindow("globalThr");
			print(minPcontSize);
			//run("Invert");
			if (bigpart==contrC) {
				run("Make Binary");
				run ("Analyze Particles...", "size=minPcontSize-Infinity show=Masks");	
				run("Invert");
			}
			else {
				//run("Invert");
				run("Make Binary");
				run ("Analyze Particles...", "size=0-minPcontSize show=Masks");
				run("Invert");
			}
			
			particles=contrC;
			//run("Invert");
			fillparticles();
			//contrC=getImageID();
			if (particles==tc)
				saveAs(path4);
			else
				saveAs(path3);
			//run("Invert");
			rename("contrThr2");
		}
//manual corrections to target components
//*************************************	
		open(path2);
		rename("bkg");
		run("Invert");
		imageCalculator("Difference create", "bkg", "contrThr2");
		run("Make Binary");
		rename("nonCon");
		//if(thrch=="size?")
		//run("Invert");//why?
		close("bkg");
		close("contrThr2");
		selectWindow("nonCon");

		Dialog.create("Apply size filter?");
		Dialog.addCheckbox("Size filter", 1);
		Dialog.addNumber("Enter minimum particle size in pixels (smaller particles will be removed)", 10);
		Dialog.show();
		sizefilt=Dialog.getCheckbox();
		minP2size=Dialog.getNumber();
		if (sizefilt==1) {
			run("Analyze Particles...", "size=minP2size-Infinity pixel show=Masks");
			run("Invert");
			close("nonCon");
		}

		tcready=getImageID();
		opac=50;
		if (contrC==tc)
			particles=ntc;
		else 
			particles=tc;
		//run("Invert");
		fillparticles();
		if (particles==tc)
			saveAs(path4);
		else
			saveAs(path3);
		close();
		open(path4);
		disconnectparticles();
		particles=tc;
		close("*");
	
//run calculations
//**************************************	
		print("\\Clear");
		comp_measurements();
		close("*");
		print("\\Clear");
		close("Results");	
		close("ROI Manager");
	}
}
