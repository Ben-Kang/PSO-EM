# PSO-EM

This is a demo implementation of our 3D-to-2D registration (pose estimation) algorithm published in [1] and [2].  It is provided for research purposes.

Version: 1.0.0  Date: May 12, 2016

# Introduction

2-D-to-3-D registration is critical and fundamental in image-guided interventions. It could be achieved from single image using paired point correspondences between the object and the image. **The common assumption that paired point correspondences can readily be established does NOT necessarily hold** for image guided interventions. Intraoperative image clutter and an imperfect feature extraction method may introduce false detection and, due to the physics of X-ray imaging, the 2-D image point features may be indistinguishable from each other and/or obscured by anatomy causing false detection of the point features. These create difficulties in establishing correspondences between image features and 3-D data points. In this paper, we propose an accurate, robust, and fast method to accomplish 2-D-to-3-D registration **using a single image without the need for establishing paired correspondences in the presence of false detections**. We formulate 2-D-3-D registration as a maximum likelihood estimation problem, which is then solved by **embeding Expectation Maximization (EM) in Particle Swarm Optimization (PSO)**. The proposed method was evaluated in a phantom and a cadaver study. In the phantom study, it achieved **subdegree rotation errors** and **submillimeter in-plane (X-Y plane) translation errors**. In both studies, it outperformed the state-of-the-art methods that do not use paired correspondences and achieved the same accuracy as a state-of-the-art global optimal method that uses correct paired correspondences.

# Experiment Results
## Phantom Study
<iframe width="640" height="360" src="https://www.youtube.com/embed/XgQBXPwkW1w?showinfo=0" frameborder="0" allowfullscreen></iframe>

The **correspondence map** is a visualization of the correspondence probabilities $$p_{mn}$$ with the horizontal axis the order of image points and the vertical axis the order of model points. The higher the value of a block in the map is, the higher the correspondence probability is.

### Robustness to A Large Amount of Outliers
<iframe width="640" height="360" src="https://www.youtube.com/embed/FxADwn2lnqs?showinfo=0" frameborder="0" allowfullscreen></iframe>

## Cadaver Stady
<iframe width="640" height="360" src="https://www.youtube.com/embed/qkwaYUClXhA?showinfo=0" frameborder="0" allowfullscreen></iframe>

### Compare to SoftPOSIT
<iframe width="480" height="360" src="https://www.youtube.com/embed/crc4_oyl1bc?showinfo=0" frameborder="0" allowfullscreen></iframe>

# How To Start

Rum the demo.m.

# Dependency

The source code is self-contained.

The Particle Swarm Optimization is a modified pervious version of the Constrained Particle Swarm Optimization (http://www.mathworks.com/matlabcentral/fileexchange/25986-constrained-particle-swarm-optimization).  Only the minimal required functions are included in this source code.  If you want to use the latest version of the Constrained Particle Swarm Optimization, proper modifications to the latest PSO and this source code may have to be made accordingly.

# Citation

**If used in research work, citations to the following papers are appreciated**

```latex
@Article{Kang14:TBME,
  author = {Kang, Xin and Armand, Mehran and Otake, Yoshito and Yau, Wai Pan and Cheung, Paul Y S and Hu, Yong and Taylor, Russell H.},
  title = {Robustness and accuracy of feature-based single image 2-D-3-D registration without correspondences for image-guided intervention},
  journaltitle = {IEEE Trans. Biomed. Eng.},
  year = {2014},
  volume = {61},
  number = {1},
  pages = {149--161},
  doi = {10.1109/TBME.2013.2278619},
}

@inproceedings{Kang11:SPIE,
author = {Kang, X. and Taylor, R. H. and Armand, M. and Otake, Y. and Yau, W. P. and Cheung, P. Y. S. and Hu, Y.},
title = {Correspondenceless 3D-2D registration based on expectation conditional maximization},
booktitle = {Prog. Biomed. Opt. Imaging - Proc. SPIE},
pages = {79642Z},
year = {2011}
month = {Mar},
doi = {10.1117/12.878618},
volume = {7964},
}
```

# Contact Info

**Important:** If you work in a research institution, university, company or you are a freelance and you are using PSOEM in your work, please send me an email!! I would like to know the people that are using PSOEM around the world!!

In case you have any question, find any bug in the code or want to share some improvements, please contact me at: ben.xkang28@gmail.com
