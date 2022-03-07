run("Clear Results");
print("\\Clear");

input=getDirectory("Choose directory");
savedir=input;

Dialog.create("Define components and run type");
Dialog.addString("Target component:", "crystals");
Dialog.addString("Non-target component:", "glass");
Dialog.addString("Background component:", "voids");
Dialog.show();
tc=Dialog.getString();
ntc=Dialog.getString();
bkg=Dialog.getString();

path1=savedir+File.separator+"-crop.tif";
path2=savedir+File.separator+"-"+bkg+".tif";
path3=savedir+File.separator+"-"+ntc+".tif";
path4=savedir+File.separator+"-"+tc+".tif";
path5=savedir+File.separator+"-results.csv";
path6=savedir+File.separator+"-fractions.txt";
path7=savedir+File.separator+"-croparea.tif";


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
//tccanvas=(imagearea-ntcarea);
//print(tc+" canvas area (total minus "+ntc+" area) = " + tccanvas);
//tcpercent=((tcs/tccanvas)*100);
//print (tc+" canvas coverage (%) = " + tcpercent);
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
run("Invert"); //***************************************************************************
Dialog.create("Edges");
Dialog.addCheckbox("Exclude "+tc+" on edges from single-particle measurements?", 1);
Dialog.show();
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
print(Table.headings);
for (b = nResults-4; b<nResults; b++) {
	row=b;
	line=" ";
	for (a=0; a<lengthOf(headings); a++)
		line = line + getResultString(headings[a],row) + " ";
	print(line);
}
selectWindow("Log");
save(path6);
close("*");