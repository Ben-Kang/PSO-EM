# README - PSO-EM

This is a demo implementation of our 3D-to-2D registration (pose estimation) algorithm published in [1] and [2]. It is provided for research purposes.

Version: 1.0.0  Date: May 12, 2016

# Introduction

2-D-to-3-D registration is critical and fundamental in image-guided interventions. It could be achieved from single image using paired point correspondences between the object and the image. **The common assumption that paired point correspondences can readily be established does not necessarily hold** for image guided interventions. Intraoperative image clutter and an imperfect feature extraction method may introduce false detection and, due to the physics of X-ray imaging, the 2-D image point features may be indistinguishable from each other and/or obscured by anatomy causing false detection of the point features. These create difficulties in establishing correspondences between image features and 3-D data points. In this paper, we propose an accurate, robust, and fast method to accomplish 2-D-to-3-D registration **using a single image without the need for establishing paired correspondences in the presence of false detections**. We formulate 2-D-3-D registration as a maximum likelihood estimation problem, which is then solved by **embeding expectation maximization (EM) with particle swarm optimization (PSO)**. The proposed method was evaluated in a phantom and a cadaver study. In the phantom study, it achieved **subdegree rotation errors** and **submillimeter in-plane (X-Y plane) translation errors**. In both studies, it outperformed the state-of-the-art methods that do not use paired correspondences and achieved the same accuracy as a state-of-the-art global optimal method that uses correct paired correspondences.

# Dependency

The Particle Swarm Optimization is a modified pervious version of the Constrained Particle Swarm Optimization (http://www.mathworks.com/matlabcentral/fileexchange/25986-constrained-particle-swarm-optimization). 

Only the minimal required functions are included in this source code.  If you want to use the latest version of the Constrained Particle Swarm Optimization, proper modifications to the latest PSO and this source code may have to be made accordingly.

# Citation

**If used in research work, citations to the following papers are required**

1. X. Kang, M. Armand, Y. Otake, W.-P. Yau, P. Y. S. Cheung, Y. Hu, & R. H. Taylor. **Robustness and Accuracy of Feature-Based Single Image 2-D–3-D Registration Without Correspondences for Image-Guided Intervention**. IEEE Transactions on Bio-Medical Engineering, 61(1), 149–161, 2014. http://doi.org/10.1109/TBME.2013.2278619

2. X. Kang, R. H. Taylor, M. Armand, Y. Otake, W. P. Yau, et al. **Correspondenceless 3D-2D Registration Based on Expectation Conditional Maximization**, Proc. SPIE 7964, Medical Imaging 2011: Visualization, Image-Guided Procedures, and Modeling, 79642Z, 2011. http://dx.doi.org/10.1117/12.878618

# Contact Info

**Important:** If you work in a research institution, university, company or you are a freelance and you are using PSOEM in your work, please send me an email!! I would like to know the people that are using PSOEM around the world!!

In case you have any question, find any bug in the code or want to share some improvements, please contact me at: ben.xkang28@gmail.com
