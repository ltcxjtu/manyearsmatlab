function myMicST=micstInit(myParameters,position,gain)
	myMicST.MICST_ALPHAD = myParameters.P_MICST_ALPHAD;
    myMicST.MICST_C = myParameters.GLOBAL_C;
    myMicST.MICST_DELTA = myParameters.P_MICST_DELTA;
    myMicST.MICST_FRAMESIZE = myParameters.GLOBAL_FRAMESIZE;
    myMicST.MICST_HALFFRAMESIZE = myMicST.MICST_FRAMESIZE / 2;
    myMicST.MICST_FS = myParameters.GLOBAL_FS;
    myMicST.MICST_GAMMA = myParameters.P_MICST_GAMMA;
    myMicST.MICST_OVERLAP = myParameters.GLOBAL_OVERLAP;
    myMicST.gain = gain;
    myMicST.position(1) = position(1);
    myMicST.position(2) = position(2);
    myMicST.position(3) = position(3);
    myMicST.ksi= zeros( myMicST.MICST_FRAMESIZE,1);
    myMicST.lambda= zeros( myMicST.MICST_FRAMESIZE,1);
    myMicST.lambda_prev= zeros( myMicST.MICST_FRAMESIZE,1);
    myMicST.sigma= zeros( myMicST.MICST_FRAMESIZE,1);
    myMicST.xfreqImag= zeros( myMicST.MICST_FRAMESIZE,1);
    myMicST.xfreqReal= zeros( myMicST.MICST_FRAMESIZE,1);
    myMicST.xpower= zeros( myMicST.MICST_FRAMESIZE,1);
    myMicST.xpower_prev= zeros( myMicST.MICST_FRAMESIZE,1);
    myMicST.xtime= zeros( myMicST.MICST_FRAMESIZE,1);
    myMicST.xtime_windowed= zeros( myMicST.MICST_FRAMESIZE,1);
    myMicST.zeta= zeros( myMicST.MICST_FRAMESIZE,1);
    myMicST.zeta_prev= zeros( myMicST.MICST_FRAMESIZE,1);
    myMicST.weightedResultImag= zeros( myMicST.MICST_FRAMESIZE,1);
    myMicST.weightedResultReal= zeros( myMicST.MICST_FRAMESIZE,1);
    for k=1:myMicST.MICST_FRAMESIZE
        myMicST.ksi(k) = 0;
        myMicST.lambda(k) = 0;
        myMicST.lambda_prev(k) = 0;
        myMicST.sigma(k) = 0;
        myMicST.xfreqImag(k) = 0;
        myMicST.xfreqReal(k) = 0;
        myMicST.xpower(k) = 0;
        myMicST.xpower_prev(k) = 0;
        myMicST.xtime(k) = 0;
        myMicST.xtime_windowed(k) = 0;
        myMicST.zeta(k) = 0;
        myMicST.zeta_prev(k) = 0;
        myMicST.weightedResultImag(k) = 0;
        myMicST.weightedResultReal(k) = 0;
    end

    myMicST.noiseEstimator=mcraInit(myParameters, myMicST.MICST_FRAMESIZE);

end


function myMCRA=mcraInit(myParameters, size)
    myMCRA.MCRA_ALPHAD = myParameters.P_MCRA_ALPHAD;
    myMCRA.MCRA_ALPHAP = myParameters.P_MCRA_ALPHAP;
    myMCRA.MCRA_ALPHAS = myParameters.P_MCRA_ALPHAS;
    myMCRA.MCRA_DELTA = myParameters.P_MCRA_DELTA;
    myMCRA.MCRA_L = myParameters.P_MCRA_L;
    myMCRA.MICST_FRAMESIZE = size;
    myMCRA.MICST_HALFFRAMESIZE = myMCRA.MICST_FRAMESIZE / 2;

    myMCRA.MCRA_BSIZE = myParameters.GLOBAL_BSIZE;
    myMCRA.MCRA_WINDOW = zeros(3,1);

    %****the .b is for smooth of spectrum;
    myMCRA.MCRA_WINDOW(1) = myParameters.GLOBAL_WINDOW0;
    myMCRA.MCRA_WINDOW(2) = myParameters.GLOBAL_WINDOW1;
    myMCRA.MCRA_WINDOW(3) = myParameters.GLOBAL_WINDOW2;
    myMCRA.firstProcessing = 1;

    myMCRA.l = 1;
    myMCRA.b=zeros(myMCRA.MCRA_BSIZE,1);
    myMCRA.S=zeros(myMCRA.MICST_FRAMESIZE,1);
    myMCRA.S_min=zeros(myMCRA.MICST_FRAMESIZE,1);
    myMCRA.S_min_prev=zeros(myMCRA.MICST_FRAMESIZE,1);
    myMCRA.S_prev=zeros(myMCRA.MICST_FRAMESIZE,1);
    myMCRA.S_tmp=zeros(myMCRA.MICST_FRAMESIZE,1);
    myMCRA.S_tmp_prev=zeros(myMCRA.MICST_FRAMESIZE,1);
    myMCRA.Sf=zeros(myMCRA.MICST_FRAMESIZE,1);
    myMCRA.lambdaD=zeros(myMCRA.MICST_FRAMESIZE,1);
    myMCRA.lambdaD_next=zeros(myMCRA.MICST_FRAMESIZE,1);
    for i=1:myMCRA.MCRA_BSIZE
        myMCRA.b(i) = myMCRA.MCRA_WINDOW(i);
    end

    for k=1:myMCRA.MICST_FRAMESIZE
        myMCRA.S(k) = 0;
        myMCRA.S_min(k) = 0;
        myMCRA.S_min_prev(k) = 0;
        myMCRA.S_prev(k) = 0;
        myMCRA.S_tmp(k) = 0;
        myMCRA.S_tmp_prev(k) = 0;
        myMCRA.Sf(k) = 0;
        myMCRA.lambdaD(k) = 0;
        myMCRA.lambdaD_next(k) = 0;
    end
end
