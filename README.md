# PSO-EM

This is a reference implementation of our 3D-to-2D registration (pose estimatio) work published in [1] and [2].

2-D-to-3-D registration is critical and fundamental in image-guided interventions. It could be achieved from single image using paired point correspondences between the object and the image. **The common assumption that paired point correspondences can readily be established does not necessarily hold** for image guided interventions. Intraoperative image clutter and an imperfect feature extraction method may introduce false detection and, due to the physics of X-ray imaging, the 2-D image point features may be indistinguishable from each other and/or obscured by anatomy causing false detection of the point features. These create difficulties in establishing correspondences between image features and 3-D data points. In this paper, we propose an accurate, robust, and fast method to accomplish 2-D-to-3-D registration **using a single image without the need for establishing paired correspondences in the presence of false detections**. We formulate 2-D-3-D registration as a maximum likelihood estimation problem, which is then solved by **embeding expectation maximization (EM) with particle swarm optimization (PSO)**. The proposed method was evaluated in a phantom and a cadaver study. In the phantom study, it achieved **subdegree rotation errors** and **submillimeter in-plane (X-Y plane) translation errors**. In both studies, it outperformed the state-of-the-art methods that do not use paired correspondences and achieved the same accuracy as a state-of-the-art global optimal method that uses correct paired correspondences.


# Demo Video Clip

Youtube embeding?

# Third-party Code

The Particle Swarm Optimization is a modified pervious version of "Constrained Particle Swarm Optimization" (http://www.mathworks.com/matlabcentral/fileexchange/25986-constrained-particle-swarm-optimization). 

# Citation

When using this source code, you need to cite the reference [1] and [2].

[1] X. Kang, M. Armand, Y. Otake, W.-P. Yau, P. Y. S. Cheung, Y. Hu, & R. H. Taylor, (2014). Robustness and Accuracy of Feature-Based Single Image 2-D–3-D Registration Without Correspondences for Image-Guided Intervention. IEEE Transactions on Bio-Medical Engineering, 61(1), 149–161. http://doi.org/10.1109/TBME.2013.2278619

[2] X. Kang, R. H. Taylor, M. Armand, Y. Otake, W. P. Yau, et al. "Correspondenceless 3D-2D registration based on expectation conditional maximization", Proc. SPIE 7964, Medical Imaging 2011: Visualization, Image-Guided Procedures, and Modeling, 79642Z (March 01, 2011); http://dx.doi.org/10.1117/12.878618