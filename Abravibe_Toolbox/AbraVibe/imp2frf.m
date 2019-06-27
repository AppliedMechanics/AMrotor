function [H,f,C,Tff] = imp2frf(x,y,fs,N,TrigPerc,PreTrigger,FWinLength,ExpWinPar,Plot)
% IMP2FRF  Calculate FRF(s) from impact time data recording (internal function)
%
%        [H,f,C,Tff] = imp2frf(x,y,fs,N,TrigPerc,PreTrigger,FWinLength,ExpWinPar,Plot)
%
%           H           Frequency response(s), N/2+1-by-D
%           f           Frequency axis, N/2+1-by-1
%           C           Coherence function(s), N/2+1-by-D
%           Tff         Transient spectrum of force signal
%
%           x           Force vector
%           y           Response signal(s) in D column(s)
%           fs          Sampling frequency
%           N           Block size for FFT
%           TrigPerc    Trigger level in percent of max(abs(x))
%           PreTrigger  Pretrigger in samples (integer > 0)
%           FWinLength  Force window in percent of N
%           ExpWinPar   End value of exponential window in percent
%           Plot        Logical variable, if Plot=1, 
%
% See also IMPSETUP IMPMASSCAL IMPPROC IMPTRIG AFORCEW AEXPW
%

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

% Find lengths and dimensions
D=length(y(1,:));
if length(x(1,:)) > 1
    x=x(:,1);
end
if length(y(1,:)) > 1
    D=length(y(1,:));       % Number of responses
end

% Find triggers in x, if too few triggers found, reduce trigger level
[TrigIdx,DIdx]=imptrig(x,N,TrigPerc,PreTrigger);
% if length(TrigIdx) < 2
%     while length(TrigIdx) < 2
%         fprintf('No triggers found. Changing trigger level to %f\n',TrigPerc/2);
%         TrigPerc=TrigPerc/2;
%         [TrigIdx,DIdx]=imptrig(x,N,TrigPerc,PreTrigger);
%     end
% end

if TrigIdx == 0
    H=[];
    f=[];
    C=[];
    Tff=[];
else
    h=impplot1(x,y(:,1),fs,N,TrigIdx,DIdx);
%     % Plot force and response signals in blue. Mark the "good" length N blocks
%     % with no double impacts in green, and double impact blocks in red
%     t=makexaxis(x,1/fs);
%     hTime=figure;
%     subplot(2,1,1)
%     plot(t,x)
%     title('Force signal (blue) and triggered blocks (green); double impact (red)')
%     hold on
%     for n=1:length(TrigIdx)
%         idx=TrigIdx(n):TrigIdx(n)+N-1;
%         plot(t(idx),x(idx),'g')
%     end
%     if DIdx ~= 0
%         for n = 1:length(DIdx)
%             idx=DIdx(n):DIdx(n)+N-1;
%             plot(t(idx),x(idx),'r')
%         end
%     end
%     grid
%     hold off
%     subplot(2,1,2)
%     plot(t,y)
%     hold on
%     for n=1:length(TrigIdx)
%         idx=TrigIdx(n):TrigIdx(n)+N-1;
%         plot(t(idx),y(idx),'g')
%     end
%     if DIdx ~= 0
%         for n = 1:length(DIdx)
%             idx=DIdx(n):DIdx(n)+N-1;
%             plot(t(idx),y(idx),'r')
%         end
%     end
%     grid
    
    % Ask user to select impacts to use
    fprintf('Select impacts by clicking on each (green) impact you want to include\n')
    fprintf('Click return when done.\n')
    [xx,d]=ginput;
    % Find closest trigger events, if no events were selected, use them all!
    if ~isempty(xx)
        xx=round(xx*fs);        % Scale in idx number
        for n=1:length(xx)
            [m,I]=min(abs(TrigIdx-xx(n)));
            T(n)=TrigIdx(I);    % Selected trigger index(es)
        end
    else
        T=TrigIdx;
    end
    close(h)
    
    % Use the selected impacts to calculate FRF etc for each response (column)
    % in y
    yin=y; clear y
    for k = 1:D
        y=yin(:,k);
        L=N/2+1;
        Tyf=zeros(L,1);
        Tyy=zeros(L,1);
        Tff=zeros(L,1);
        fw=aforcew(N,FWinLength);
        ew=aexpw(N,ExpWinPar);
        for n=1:length(T)
            F=x(T(n):T(n)+N-1);
            F=F-F(1);
            F=F.*fw.*ew;
            Ff=fft(F);
            Ff=Ff(1:L);
            Y=y(T(n):T(n)+N-1);
            Y=Y.*ew;
            Yf=fft(Y);
            Yf=Yf(1:L);
            Tyf=Tyf+(Yf.*conj(Ff));
            Tyy=Tyy+abs(Yf).^2;
            Tff=Tff+abs(Ff).^2;
        end
        H(:,k)=Tyf./Tff;
        f=(0:fs/N:fs/2);
        C(:,k)=abs(Tyf).^2./Tff./Tyy;
        Tff(:,k)=Tff/n/fs;               % Transient average spectrum
        if exist('Plot','var')
            if Plot
                figure
                subplot(3,1,1)
                semilogy(f,abs(H))
                ylabel('FRF')
                subplot(3,1,2)
                plot(f,C)
                ylabel('Coherence')
                subplot(3,1,3)
                semilogy(f,Tff)
                ylabel('Force Spec.')
                xlabel('Frequency [Hz]')
            end
        end
    end
end