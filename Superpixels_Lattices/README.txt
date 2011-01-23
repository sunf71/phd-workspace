Superpixel Lattice v0.1 win32 MATLAB 7.5

Alastair Moore
Prince Vision Lab
Department of Computer Science
University College London, UK
Copyright (c) 2008
All Rights Reserved.

UNIVERSITY COLLEGE LONDON AND THE CONTRIBUTORS TO THIS WORK
DISCLAIM ALL WARRANTIES WITH REGARD TO THIS SOFTWARE, INCLUDING
ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS, IN NO EVENT
SHALL UNIVERSITY COLLEGE LONDON NOR THE CONTRIBUTORS BE LIABLE FOR 
ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER
RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF 
CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.


USAGE:

This software package is provided for research purposes only. We hope it will be useful!

It is a new implementation of the algorithm reported in:

BibTex entry

@ARTICLE{MooreEtAl08,
  author = {Alastair P Moore, Simon J D Prince, Jonathan Warrell, Umar Mohammed and Graham Jones},
  title = {Superpixel {L}attices},
  journal = {CVPR},
  year = {2008},
  volume = {},
  pages = {},
  url = {http://www.cs.ucl.ac.uk/staff/s.prince/Papers/SuperpixelLattices.pdf}
}

Please use this paper for reference.

This package is for MS Windows ONLY, and it includes:

(1) A mex file dll (grl.mexw32)
(2) A Matlab script 'grlDemo.m' to demonstrate use
(3) A test image from the Berkeley training images: David Martin, Charless Fowlkes and Jitendra Malik,"Learning to Detect Natural Image Boundaries Using Local Brightness, Color and Texture Cues", PAMI,26(5), 530-549, May 2004. 
(4) A test boundary image (bndImg) using the BEL algorithm v1.5: Piotr Dollar, Zhuowen Tu, and Serge Belongie, "Supervised Learning of Edges and Object Boundaries", CVPR, June, 2006.
(5) A copy of the paper.

Code updates and bug fixes can be found via http://pvl.cs.ucl.ac.uk/

There are a few simple modifications that can be made to improve performance
which will be made available in due course along with a 3D version, described in Section
6 of the paper, that can be applied to video.
