This is the MATLAB implementation of the saliency detection method implemented in the paper: 

A dense subgraph based algorithm for compact salient image region detection.
 

Run "Demo.m" to obtain the saliency maps for the given sample input images. Images are read from the folder "/input", and the corresponding saliency maps are saved in "/output".

This code uses the SLIC superpixel algorithm from this paper:

R. Achanta, A. Shaji , K. Smith, A. Lucchi, P. Fua and S. Susstrunk, "SLIC Superpixels Compared to State-of-the-Art Superpixel Methods," IEEE Trans. Pattern Anal. Mach. Intell., vol 34, no. 11, pp. 2274 - 2282, May. 2012, and,

Compactness finding procedure from:

J. S. Kim, J. Y. Sim and C. S. Kim, "Multiscale Saliency Detection Using Random Walk with Restart", IEEE Trans. Circuits Syst. Video Techn., vol 24, no. 2, pp. 198-210, Feb. 2014 

The results obtained from this code vary a bit with the results shown in the paper due to certain algorithm parameters (such as gamma, alpha, etc.) being different due to experimental reasons, as well as, due to the fact that the algorithm in this code has not been implemented with computation in different scales and then combining, as followed in the original paper. We will soon publish our complete code.

============================================================
Please cite the following paper when you report the results using the code:

Souradeep Chakraborty and Pabitra Mitra, "A dense subgraph based algorithm for compact salient image region detection," Computer Vision and Image Understanding, 2015.

Available Online at: 
http://www.sciencedirect.com/science/article/pii/S1077314215002696 

