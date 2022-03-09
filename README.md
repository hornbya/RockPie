# RockPie
RockPie - ImageJ macro for segmentation of SEM imagery into three components

The macro is based on the Ash-surface-salts macro described in Casas et al. Bull Volcanol 84, 3 (2022) - https://doi.org/10.1007/s00445-021-01519-3 - https://github.com/hornbya/Ash-surface-salts - and is designed to segment 8-bit images into three components defined by greyscale shade and/or relative component size. 
The macro uses a set of plugins: MorphoLibJ https://imagej.net/MorphoLibJ (doi.org/10.1093/bioinformatics/btw413), Shape Filter https://imagej.net/Shape_Filter (http://dx.doi.org/10.5334/jors.ae), Non-local means denoising https://imagej.net/plugins/non-local-means-denoise/index, (Beat) Disconnect Particles plugins https://imagej.net/people/bmuench and Read and Write Excel (https://imagej.net/User:ResultsToExcel).
Calculation-only functions and data table management standalone macros work as described here https://github.com/hornbya/Ash-surface-salts

Requirements: ImageJ or Fiji v1.52 or newer with a set of plugins enabled by subscribing to the following update sites (via Help > Update… >Manage Update Sites)
-	Biomedgroup (Shape Filter and Non-Local Means Denoise)
-	IJPB-plugins (MorphoLibJ)
-	Xlib (Disconnect Particles)
-	ResultsToExcel (Read and Write Excel)

March 2022: v1.1. Segmentation by greyscale path working. Segmentation by size working so long as the 'target' and 'non-target' components are defined for size segmentation (e.g. - make sure the background really is the background for this measurement).

Native image processing and 'cleanup' options are added and segmentation by greyscale path improved.
- NLMD-processed images now persist through all thresholding steps
- Remove Outliers option added to manual editing function (along with image editing hint message)
- Disconnect Particles function and Shape filter binary-switching bugs fixed.
- Message added to select the target and non-target components carefully for size segmentation
- Brightness and contrast option replaced with Window/Level and instruction message added
- Bandpass filter is now initially a checkbox option (same 'preview first' sequence applies if selected)

- Deleted unnecesary waitforuser prompts
- Deleted redundant dThr option
- Changed all optional image processing checkbox defaults to unchecked

The macro has tested using Windows 10, but there should be no compatibility issues with recent versions of Windows or Mac OSs. Most image formats are accepted by ImageJ.
The macro is designed for use with greyscale images. A range of SEM-SE and BSE images have been tested, but the macro should cope with color images converted to 8-bit greyscale if there is enough contrast between components.
The macro needs to be loaded into ImageJ. You can add it into the ‘macros’ folder in the ImageJ directory, but I prefer to run it through the editor – Plugins > Macros > Edit…

The macro requires the user to define a set of three components – Components are defined as 'target' (the component of interest, with fractional and morphometric data), 'non-target' (an additional component, with fractional data only) and 'background' (with fractional data only). For example, in volcanic rock sections, these could be crystals, glass and voids, respectively.

1.	Target component - the target component will also be measured by Shape Filter to give a set of morphometric parameters on a single particle basis.
2.	Non-target component – this is another feature, phase or particle type distinguished from the target component by either size, greyscale, or a combination of the two.
3.	Background – this can be void space or another component in the image – it should be distinguished from the other two components by greyscale.

The components are separated by a semi-automated set of image processing and thresholding steps together with options for manual correction at each step.
Seven files are saved into an output folder of the users choice.

The three component images (3), a cropped input image and a blank image (for total area) are saved as .TIF files, plus a text file with the component fractions and area and a .CSV file with morphometric data for target component.
The macro can be run in either single-image or batch mode. Batch mode will open the next image in a folder automatically after processing is finished. Output data are saved all into individual folders by image name.

For analysis of a set of images, I recommend storing them all in a single folder and creating a folder named 'output' in the same directory before starting to process the images

Please let me know of any issues or bugs and I’ll be happy to try to sort them.
Hope you enjoy!

Adrian
adrianhornby@gmail.com
