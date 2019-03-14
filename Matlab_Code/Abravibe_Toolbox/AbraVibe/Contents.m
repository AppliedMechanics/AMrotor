% ABRAVIBE MATLAB/Octave Toolbox for Noise & Vibration Analysis
% Version 2.0	2018-05-12 
% Tested under MATLAB rel. 2018a, Octave 3.2.4 (both Windows)
% Copyright (c) 2009-2018 by Anders Brandt, University of Southern Denmark
% Email: abra@iti.sdu.dk
% ----------------------------------------------------------------------
% ABRAVIBE is an accompanying toolbox intended for use with the book:
% Brandt, A. (2011): Noise and Vibration Analysis: Signal Analysis and
% Experimental Procedures, John Wiley and Sons, ISBN 978-0470746448.
% ----------------------------------------------------------------------
% This toolbox is FREE SOFTWARE published under the GNU General Public
% License. See the license file in the software directory for details.
% ----------------------------------------------------------------------
%
% A word on command names:
% To avoid confusion with many rather common functions, many of the
% commands in this toolbox start with an 'a' for 'abravibe'. I hope this
% helps. :-)
%
% Help: type for example:
% >> help abravibe
% to get help for a specific command in the list below (replace abravibe).
% ----------------------------------------------------------------------
% About
% -------------------
%   abrabout      - Type abrabout to print some information on screen
%
% Helpful functions
% -------------------
%   checksw       - Check if running MATLAB or GNU/Octave
%   makexaxis     - Create a time or frequency x axis
%   makepulse     - Calculate a Gaussian or halfsine pulse
%
% Data storage info
% -------------------
%   abra2imp      - Convert general ABRAVIBE time data files to .imptime format
%   abrahead      - Check if header structure is a valid ABRAVIBE header
%   datahelp      - Prints documentation for Abravibe data storage (Data and Header variables)
%   dir2nbr       - Convert Header direction string to number
%   dofdir2n      - Convert dof number and dir string to numeric format
%   functype      - Convert between numeric and string function type
%   headpstr      - Create string out of Abravibe header Dof and Dir info
%   makehead      - Make an empty ABRAVIBE header structure
%   nbr2dir       - Convert numeric direction to string
%   n2dofdir      - Convert dof numeric format to dof number and numeric dir  
%
% Universal file import/export
% -------------------
%   abra2modstr   - Convert ABRAVIBE modal information files into structure
%   makemhead     - Make a default MODAL header
%   unvread       - Read a standard UNV file
%   unvwrite      - Write a universal file
%
% Statistics analysis
% -------------------
%   apdf          - Calculate and plot probability density function, PDF
%   acrest        - Calculate crest factor
%   akurtosis     - Calculate kurtosis
%   amoment       - Calculate statistical moment
%   arms          - RMS calculation by 'analog' or linear integration 
%   askewness     - Calculate skewness
%   framestat     - Calculate frame statistics of signal
%   statchk       - Create standard statistics for time signal(s) in matrix
%   statchkf      - STATCHK Create standard statistics for time signal(s) in ABRAVIBE files
%   teststat      - Hypothesis test for stationarity
%
% Time data processing
% -------------------
%   afcoeff       - Compute filter coefficients for time domain filters
%   apceps        - Calculate power cepstrum of single-sided autospectrum
%   axcorr        - Scaled cross-correlation between x (input) and y (output)
%   axcorrp       - Scaled cross-correlation between x (input) and y (output)
%   smoothfilt    - Simple smoothing filter for time domain data
%   timeavg       - Create synchronuous time average using blocksize N
%   timediff      - Differentiate time signal 
%   timeint       - Integrate time signal 
%   timeweight    - Filter data with time weighting filter in time domain
%   time2corr     - Process ABRAVIBE time data files into correlation function files
%   time2spec     - TIME2CORR    Process ABRAVIBE time data files into spectral density function files
%   winsmooth     - SMOOTHFILT Smooth data with any smoothing window
%
% Acoustics and octave bands
% -------------------
%   aweighf       - Calculate A-weighting curve for A-weighting a spectrum
%   cweighf       - Calculate C-weighting curve for C-weighting a spectrum
%   noctfilt      - Calculate filter coefficients for fractional octave band filter
%   noctfreqs     - Compute the exact midband frequencies for a 1/n octave analysis
%   noctlimits    - Calculate IEC/ANSI limits for fractional octave filter
%   spec2noct     - Calculate 1/n octave spectrum from an FFT spectrum
%
% Frequency Analysis
% -------------------
%   acsdsp        - Cross-Spectral Density, CSD, by smoothed periodogram method
%   acsdw         - Calculate cross PSD from time data, Welch's method (standard)
%   aenvspec      - Calculate envelope spectrum
%   alinspec      - Calculate linear (rms) spectrum from time data
%   alinspecp     - Calculate linear (rms) spectrum of time data, with phase
%   apsdsp        - Power Spectral Density, PSD, by smoothed periodogram
%   apsdw         - Calculate auto PSD from time data, Welch's method (standard)
%   atranspec     - Calculate (linear) transient spectrum
%   chkbsize      - Compare up to three blocksizes for PSD calculation (Welch's method)
%   fdiff         - Frequency differentiation by jw multiplication
%   fint          - Frequency integration by jw division
%   fnegfreq      - Create negative frequencies by mirroring positive
%   nskipblocks   - Extract every NoSkip+1 blocks with size N from x
%   time2xmtrx    - Calculate In-/Out cross spectral matrices for MIMO analysis
%   time2xmtrxc   - Computes In-/Out cross spectral matrices from time data by cyclic averaging
%   welcherr      - Random error in PSD estimate with Welch's method 
%
% Time windows etc. (Also see impact testing post processing)
% -------------------
%   aflattop      - Calculate flattop window
%   ahann         - Calculate a Hanning window
%   hsinew        - Calculate half sine time window
%   winacf        - Calculate amplitude correction factor of time window
%   winenbw       - Calculate equivalent noise bandwidth of time window
%
% Linear Systems Analysis
% -------------------
%   frf2ir        - Convert freqency response(s) to impulse response(s)
%   frfim2re      - FRFRE2IM  Create FRF with Real part from Hilbert transform of imaginary part
%   frfre2im      - Create FRF with imaginary part from Hilbert transform of real part
%   mcoh          - Calculate multiple coherence
%   xmtrx2frf     - FRF estimation (SISO, SIMO, MISO, or MIMO)
%
% Principal components and virtual coherence
% -------------------
%   apcax         - Compute principal components and cumulated virtual coherences 
%   apcaxy        - Compute cumulated virtual coherences etc. based on two sets of signals, x and y
%
% System simulation and response analysis
% -------------------
%   asrs          - Acceleration shock response spectrum, SRS
%   fz2poles      - Convert frequencies and damping to poles
%   mck2frf       - Calculate FRF(s) from M, C, K matrices
%   mck2modal     - Compute modal model (poles and mode shapes) from M,(C),K
%   mkz2frf       - Calculate FRF(s) from M, K and modal damping, z
%   mkz2modal     - Compute modal model (poles and mode shapes) from M,K, and z
%   modal2frf     - Synthesize FRF(s) from modal parameters
%   modal2frfh    - Synthesize FRF(s) from modal parameters with hysteretic damping
%   poles2fz      - Convert poles to frequencies and relative damping
%   timefresp     - Time domain forced response
%   tunedamp      - Compute FRF of tuned damper with SDOF system
%   uma2umm       - Rescale mode shapes from unity modal A to unity modal mass
%   umm2uma       - Rescale mode shapes from unity modal mass to unity modal A
% 
% Create time data for simulation
% -------------------
%   abrand        - Create burst random time data blocks in column vector
%   aprand        - Create pseudo random time data block in column vector
%   psd2time      - Generate Gaussian random signal from PSD
%
% Experimental modal analysis and operating deflection shape analysis
% -------------------
%   acomac        - AMAC  Calculate Coordinate Modal Assurance Critera matrix C from two mode sets
%   amac          - Calculate Modal Assurance Critera matrix M from two mode sets
%   amif          - Calculate mode indicator function of (accelerance) FRFs
%   data2hmtrx    - Import Abravibe FRF data into H matrix
%   enhancefrf    - Enhance FRF matrix by Singular Value Decomposition
%   frf2msdof     - Curve fit FRFs into poles and mode shapes, SDOF techniques
%   frfp2modes    - Estimate mode shapes from FRFs and poles in frequency domain
%   frf2ptime     - Time domain MDOF methods for parameter extraction
%   frfsynt       - Synthesize FRF(s) after modal parameter extraction
%   ir2ptime      - Time domain MDOF methods for parameter extraction
%   listpoles     - List undamped natural frequencies and damping factors
%   modal2pv      - Convert animate MODAL struct to separate variables
%   modalchk      - Standard checks on FRF matrix for exp. modal analysis
%   odspick       - Extract ODS shapes from phase spectrum
%   plateanim     - Animate mode shapes on plate structures (1D mode shapes)
%   plotmac       - Plot Manhattan type MAC matrix plot
%   pv2modal      - Convert separate variables to animate MODAL struct
%   sdiagramGUI   - MATLAB code for sdiagramGUI.fig. This is an internal function
%   wincomp       - Compensate poles due to exponential window from Impact testing
%
% Operational modal analysis
% -------------------
%   ir2pmitd      - ir2MITD Multi-reference Ibrahim Time domain MDOF method for OMA parameter extraction
%
% Order tracking (Rotating machinery analysis)
% -------------------
% Fix sampling frequency commands:
%   map2order     - Extract orders from RPM map, fix fs or synchronuous sampling
%   plotrpmmapc   - Plot a color map of RPM map data with fixed fs
%   plotrpmmapwf  - Plot RPM map from fix fs in waterfall format
%   rpmmap        - Compute rpm/frequency spectral map for order tracking, fixed fs
%   tacho2rpm     - Extract rpm/time profile from tacho time signal
% Synchronous sampling commands: (also use tacho2rpm and map2order above) 
%   plotrpmmapsc  - Plot a color map of RPM map data from synchronuous sampling
%   plotrpmmapswf - Plot RPM map from synchronuous sampling in waterfall format
%   rpmmaps       - Compute rpm/order spectral map for order tracking, synchronuous sampling
%   synchsampr    - Resample data synchronously with RPM, using rpm-time profile
%   synchsampt    - Resample data synchronously with RPM, based on tacho signal
%
% Impact testing post processing 
% -------------------
%   ImpactGui     - Impact testing GUI
%   aexpw         - Exponential window for impact testing
%   aforcew       - Force window for impact testing
%
% Plotting and animation
% -------------------
%   abrabrowse    - GUI-based data browser for ABRAVIBE toolbox data files
%   angledeg      - Calculate angle in degrees for complex vector(s)
%   animate       - GUI-based animation software
%   anomograph    - Plot a displacement, velocity, acceleration nomograph
%   db10          - Calculate dB for power data (units squared)
%   db20          - Calculate dB for linear data (linear units)
%   plotfile      - Plot data in ABRABIVE file(s) with default format
%   plotmagph     - Plot complex data in magnitude/phase format
%   plotreim      - Plot real and imaginary part of complex function
%   plotscan      - Scan a vector with time data and plot blockwise
% 
% Copyright 2009-2018, Anders Brandt. See license file for details.



