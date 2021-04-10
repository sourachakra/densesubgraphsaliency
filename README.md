# densesubgraphsaliency
Dense subgraph based saliency

This is the MATLAB implementation of the saliency detection method implemented in the paper: 

Chakraborty, Souradeep, and Pabitra Mitra. "A dense subgraph based algorithm for compact salient image region detection." Computer Vision and Image Understanding 145 (2016): 1-14.
Available Online at: 
http://www.sciencedirect.com/science/article/pii/S1077314215002696

Run "Demo.m" to obtain the saliency maps for the given sample input images. Images are read from the folder "/input", and the corresponding saliency maps are saved in "/output".

This code uses the SLIC superpixel algorithm from this paper: R. Achanta, A. Shaji , K. Smith, A. Lucchi, P. Fua and S. Susstrunk, "SLIC Superpixels Compared to State-of-the-Art Superpixel Methods," IEEE Trans. Pattern Anal. Mach. Intell., vol 34, no. 11, pp. 2274 - 2282, May. 2012, and Compactness finding procedure from: J. S. Kim, J. Y. Sim and C. S. Kim, "Multiscale Saliency Detection Using Random Walk with Restart", IEEE Trans. Circuits Syst. Video Techn., vol 24, no. 2, pp. 198-210, Feb. 2014 

Please cite the following paper (bibtex) if you use this code for your work:

@article{chakraborty2016dense,
  title={A dense subgraph based algorithm for compact salient image region detection},
  author={Chakraborty, Souradeep and Mitra, Pabitra},
  journal={Computer Vision and Image Understanding},
  volume={145},
  pages={1--14},
  year={2016},
  publisher={Elsevier}
}


