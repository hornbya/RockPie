//This macro uses Read and Write Excel to tranpose results columns from shape data
//output by the simple_shape macro into labelled tabs in an Excel sheet.


//*****************************************************
//***Rearranged Excel file is saved on the desktop as
//"Rename me after writing is done.xlsx"***.
//******************************************************

macro "Shape results table arrangement" {
	parent=getDirectory("Select output directory");
	list=getFileList(parent);
	Dialog.create("Column options");
	items=newArray("Area", "Perimeter", "Convex hull area", "Convex Hull Perimeter", "Solidity", "Convexity", "Form factor", "Circularity", "Roundness", "Axial ratio (Feret)", "Feret diameter", "Minimum Feret diameter", "Orientation");
	defaults=newArray(true, true, false, false, true, true, true, true, true, true, false, false, true); 
	Dialog.addMessage("Select the properties to export");
	Dialog.addCheckboxGroup(5, 3, items, defaults)
	Dialog.show();

	area=Dialog.getCheckbox();
	perimeter=Dialog.getCheckbox();
	CHarea=Dialog.getCheckbox();
	CHperimeter=Dialog.getCheckbox();
	solidity=Dialog.getCheckbox();
	convexity=Dialog.getCheckbox();
	formFactor=Dialog.getCheckbox();
	circularity=Dialog.getCheckbox();
	roundness=Dialog.getCheckbox();
	AR=Dialog.getCheckbox();
	feretD=Dialog.getCheckbox();
	minFeretD=Dialog.getCheckbox();
	orientation=Dialog.getCheckbox();
	
	for (i = 0; i < list.length; i++) {
		dirName = list[i];
		dir=parent+dirName;
		sr=dir+"-results.csv";
		length=File.length(sr);
		if (length<10)
			continue
		open(sr);
		srn=File.getName(sr);
		

		if (area==true) {
			IJ.renameResults(srn, "Results");
			//Table.deleteColumn("Area"); 
			Table.deleteColumn("Perim.");
			Table.deleteColumn("CH-Area");
			Table.deleteColumn("CH-Perim.");
			Table.deleteColumn("Solidity");
			Table.deleteColumn("Convexity"); 
			Table.deleteColumn("FormFactor");
			Table.deleteColumn("Circularity");
			Table.deleteColumn("Roundness");
			Table.deleteColumn("AR-feret"); 
			Table.deleteColumn("Feret-d");
			Table.deleteColumn("MinFeret-d");
			Table.deleteColumn("Orientation");
		
			run("Read and Write Excel", "no_count_column sheet=Area dataset_label=" +dirName);
			close("Results");
		}
		if (perimeter==true) {
			open(sr);
			IJ.renameResults(srn, "Results");
			Table.deleteColumn("Area"); 
			//Table.deleteColumn("Perim.");
			Table.deleteColumn("CH-Area");
			Table.deleteColumn("CH-Perim.");
			Table.deleteColumn("Solidity");
			Table.deleteColumn("Convexity"); 
			Table.deleteColumn("FormFactor");
			Table.deleteColumn("Circularity");
			Table.deleteColumn("Roundness");
			Table.deleteColumn("AR-feret"); 
			Table.deleteColumn("Feret-d");
			Table.deleteColumn("MinFeret-d");
			Table.deleteColumn("Orientation");
		
			run("Read and Write Excel", "no_count_column sheet=Perimeter dataset_label=" +dirName);
			close("Results");
		}
		if (CHarea==true) {
			open(sr);
			IJ.renameResults(srn, "Results");
			Table.deleteColumn("Area"); 
			Table.deleteColumn("Perim.");
			//Table.deleteColumn("CH-Area");
			Table.deleteColumn("CH-Perim.");
			Table.deleteColumn("Solidity");
			Table.deleteColumn("Convexity"); 
			Table.deleteColumn("FormFactor");
			Table.deleteColumn("Circularity");
			Table.deleteColumn("Roundness");
			Table.deleteColumn("AR-feret"); 
			Table.deleteColumn("Feret-d");
			Table.deleteColumn("MinFeret-d");
			Table.deleteColumn("Orientation");
		
			run("Read and Write Excel", "no_count_column sheet=CH_area dataset_label=" +dirName);
			close("Results");
		}
		if (CHperimeter==true) {
			open(sr);
			IJ.renameResults(srn, "Results");
			Table.deleteColumn("Area"); 
			Table.deleteColumn("Perim.");
			Table.deleteColumn("CH-Area");
			//Table.deleteColumn("CH-Perim.");
			Table.deleteColumn("Solidity");
			Table.deleteColumn("Convexity"); 
			Table.deleteColumn("FormFactor");
			Table.deleteColumn("Circularity");
			Table.deleteColumn("Roundness");
			Table.deleteColumn("AR-feret"); 
			Table.deleteColumn("Feret-d");
			Table.deleteColumn("MinFeret-d");
			Table.deleteColumn("Orientation");
		
			run("Read and Write Excel", "no_count_column sheet=CH_perim dataset_label=" +dirName);
			close("Results");
		}
		if (solidity==true) {
			open(sr);	
			IJ.renameResults(srn, "Results");
			Table.deleteColumn("Area"); 
			Table.deleteColumn("Perim.");
			Table.deleteColumn("CH-Area");
			Table.deleteColumn("CH-Perim.");
			//Table.deleteColumn("Solidity");
			Table.deleteColumn("Convexity"); 
			Table.deleteColumn("FormFactor");
			Table.deleteColumn("Circularity");
			Table.deleteColumn("Roundness");
			Table.deleteColumn("AR-feret"); 
			Table.deleteColumn("Feret-d");
			Table.deleteColumn("MinFeret-d");
			Table.deleteColumn("Orientation");
		
			run("Read and Write Excel", "no_count_column sheet=Solidity dataset_label=" +dirName);
			close("Results");
		}
		if (convexity==true) {	
			open(sr);
			IJ.renameResults(srn, "Results");
			Table.deleteColumn("Area"); 
			Table.deleteColumn("Perim.");
			Table.deleteColumn("CH-Area");
			Table.deleteColumn("CH-Perim.");
			Table.deleteColumn("Solidity");
			//Table.deleteColumn("Convexity"); 
			Table.deleteColumn("FormFactor");
			Table.deleteColumn("Circularity");
			Table.deleteColumn("Roundness");
			Table.deleteColumn("AR-feret"); 
			Table.deleteColumn("Feret-d");
			Table.deleteColumn("MinFeret-d");
			Table.deleteColumn("Orientation");
			
			run("Read and Write Excel", "no_count_column sheet=Convexity dataset_label=" +dirName);
			close("Results");
		}
		if (formFactor==true) {
			open(sr);
			IJ.renameResults(srn, "Results");
			Table.deleteColumn("Area"); 
			Table.deleteColumn("Perim.");
			Table.deleteColumn("CH-Area");
			Table.deleteColumn("CH-Perim.");
			Table.deleteColumn("Solidity");
			Table.deleteColumn("Convexity"); 
			//Table.deleteColumn("FormFactor");
			Table.deleteColumn("Circularity");
			Table.deleteColumn("Roundness");
			Table.deleteColumn("AR-feret"); 
			Table.deleteColumn("Feret-d");
			Table.deleteColumn("MinFeret-d");
			Table.deleteColumn("Orientation");
		
			run("Read and Write Excel", "no_count_column sheet=Form_factor dataset_label=" +dirName);
			close("Results");
		}
		if (circularity==true) {
			open(sr);
			IJ.renameResults(srn, "Results");
			Table.deleteColumn("Area"); 
			Table.deleteColumn("Perim.");
			Table.deleteColumn("CH-Area");
			Table.deleteColumn("CH-Perim.");
			Table.deleteColumn("Solidity");
			Table.deleteColumn("Convexity"); 
			Table.deleteColumn("FormFactor");
			//Table.deleteColumn("Circularity");
			Table.deleteColumn("Roundness");
			Table.deleteColumn("AR-feret"); 
			Table.deleteColumn("Feret-d");
			Table.deleteColumn("MinFeret-d");
			Table.deleteColumn("Orientation");
	
		run("Read and Write Excel", "no_count_column sheet=Circularity dataset_label=" +dirName);
		close("Results");
		}
		if (roundness==true) {
			open(sr);
			IJ.renameResults(srn, "Results");
			Table.deleteColumn("Area"); 
			Table.deleteColumn("Perim.");
			Table.deleteColumn("CH-Area");
			Table.deleteColumn("CH-Perim.");
			Table.deleteColumn("Solidity");
			Table.deleteColumn("Convexity"); 
			Table.deleteColumn("FormFactor");
			Table.deleteColumn("Circularity");
			//Table.deleteColumn("Roundness");
			Table.deleteColumn("AR-feret"); 
			Table.deleteColumn("Feret-d");
			Table.deleteColumn("MinFeret-d");
			Table.deleteColumn("Orientation");
			
			run("Read and Write Excel", "no_count_column sheet=Roundness dataset_label=" +dirName);
			close("Results");	
		}
		if (AR==true) {
			open(sr);
			IJ.renameResults(srn, "Results");
			Table.deleteColumn("Area"); 
			Table.deleteColumn("Perim.");
			Table.deleteColumn("CH-Area");
			Table.deleteColumn("CH-Perim.");
			Table.deleteColumn("Solidity");
			Table.deleteColumn("Convexity"); 
			Table.deleteColumn("FormFactor");
			Table.deleteColumn("Circularity");
			Table.deleteColumn("Roundness");
			//Table.deleteColumn("AR-feret"); 
			Table.deleteColumn("Feret-d");
			Table.deleteColumn("MinFeret-d");
			Table.deleteColumn("Orientation");
		
			run("Read and Write Excel", "no_count_column sheet=AR_Feret dataset_label=" +dirName);
			close("Results");
		}
		if (feretD==true) {
			open(sr);
			IJ.renameResults(srn, "Results");
			Table.deleteColumn("Area"); 
			Table.deleteColumn("Perim.");
			Table.deleteColumn("CH-Area");
			Table.deleteColumn("CH-Perim.");
			Table.deleteColumn("Solidity");
			Table.deleteColumn("Convexity"); 
			Table.deleteColumn("FormFactor");
			Table.deleteColumn("Circularity");
			Table.deleteColumn("Roundness");
			Table.deleteColumn("AR-feret"); 
			//Table.deleteColumn("Feret-d");
			Table.deleteColumn("MinFeret-d");
			Table.deleteColumn("Orientation");
		
			run("Read and Write Excel", "no_count_column sheet=Feret_d dataset_label=" +dirName);
			close("Results");
		}
		if (minFeretD==true) {
			open(sr);
			IJ.renameResults(srn, "Results");
			Table.deleteColumn("Area"); 
			Table.deleteColumn("Perim.");
			Table.deleteColumn("CH-Area");
			Table.deleteColumn("CH-Perim.");
			Table.deleteColumn("Solidity");
			Table.deleteColumn("Convexity"); 
			Table.deleteColumn("FormFactor");
			Table.deleteColumn("Circularity");
			Table.deleteColumn("Roundness");
			Table.deleteColumn("AR-feret"); 
			Table.deleteColumn("Feret-d");
			//Table.deleteColumn("MinFeret-d");
			Table.deleteColumn("Orientation");
		
			run("Read and Write Excel", "no_count_column sheet=Min_Feret_d dataset_label=" +dirName);
			close("Results");
		}
		if (orientation==true) {
			open(sr);
			IJ.renameResults(srn, "Results");
			Table.deleteColumn("Area"); 
			Table.deleteColumn("Perim.");
			Table.deleteColumn("CH-Area");
			Table.deleteColumn("CH-Perim.");
			Table.deleteColumn("Solidity");
			Table.deleteColumn("Convexity"); 
			Table.deleteColumn("FormFactor");
			Table.deleteColumn("Circularity");
			Table.deleteColumn("Roundness");
			Table.deleteColumn("AR-feret"); 
			Table.deleteColumn("Feret-d");
			Table.deleteColumn("MinFeret-d");
			//Table.deleteColumn("Orientation");
		
			run("Read and Write Excel", "no_count_column sheet=Orientation dataset_label=" +dirName);
			close("Results");
		}
		run("Close All");
	}
}