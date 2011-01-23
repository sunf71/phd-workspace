RAD MAtlab's pcode.
Eduard Vazquez 2008.

   Please, for doubts and bugs detected:

		eduard@cvc.uab.cat



  This code is public available. If you use it, just cite the ECCV article:
	@InProceedings\{VVB08a,
	  author       = "V\'azquez, E and van de Weijer, Joost and Baldrich, R",
  	title        = "Image Segmentation in the Presence of Shadows and Highligts",
	  booktitle    = "European Conference on Computer Vision (ECCV'08)",
	  series       = "Leture Notes in Computer Science",
	  volume       = "5305",
	  pages        = "1--14",
	  month        = "Oct",
	  year         = "2008",
	  editor       = "Forsyth, David andTorr, Philip and Zisserman, Andrew",
	  publisher    = "Springer",
	  address      = "Marseille (France)",
	  url          = "http://www.cat.uab.cat/Publications/2008/VVB08a"
	}



To run it:

1)Read an image to be segmented. 

	im=imread('/path_of_the_image/image.ext');

2)Then, just copy-paste:
  
	[imRes]=RAD(1.5,0.05,0.5,125,im,0);


INPUT: segmenta(integration,differentiation,thr,sizeDist,imatge)
 
   -> differentiation: size of the objects whose orientation has to be
                      determined (recommended 0.005 0.5)
  -> integration: size of the neighbourhood in which orientation is 
                    dominant (recommended 1.5, 1 0.5)
   -> thr: confidence measure. Reduce creaseness in the structures we are
           not interested in.
   -> sizeDist: \bins of the histogram. Recommended 80, 125.
   -> im = Original image
   -> super: if 1, it yields an oversegmntation
 
 
OUTPUT: [imRes]
 
  ->  imRes: segmented image.

 
To correctly display the segmented image: imshow(uint8(imRes)).



