function [H,v,mcc]=filMIMO4(X,Y,numlags,numsides,fs)
% Solves for the nonparametric filters of a MIMO linear
% system using a correlation function based approach.
%
%    USAGE:   [H,vaf,mcc]=filMIMO(X,Y,numlags,numsides,fs);
%
%
%    X        : Columnwise inputs  [x1 x2 ...] to the unknown system
%    Y        : Columnwise outputs [y1 y2 ...] to the unknown system
%    numlags  : the number of lags to calculate for all linear filters
%    numsides : determine a causal (1 side) or noncausal 
%               (2 sides) response.
%    fs		: Sampling rate (default=1)
%    H      : the identified nonparametric filters between X and Y.
%
% The returned filter matrix is organized in columns as:
%     H=[h11 h21 h31 ....;
%        h12 h22 h32 ....;
%        h13 h23 h33 ...;
%        ... ... ... ...]
%  Which represents the system:
%  y1=h11 + h12*x1 + h13*x2 + h14*x3 + ...     
%  y2=h21 + h22*x1 + h23*x2 + h24*x3 + ...     
%  y3=h31 + h32*x1 + h33*x2 + h34*x3 + ...    
%  ... 

% EJP Feb 1997, CE October 2013
%
if (nargin==4) fs=1; disp('Sampling rate set to 1.0'); 
elseif (nargin ~=5) disp('Wrong number of inputs');return;end

%if (rem(numlags,4) ~= 0 )
	%disp('numlags must be a multiple of 4');
	%return
    %end
    
  [rX,cX]= size(X); [rY,cY]= size(Y);
  numio=cX+cY;

  mx = mean(X); my = mean(Y);
  % adding the constant flag to the detrend code - just removes the mean.
  X= detrend(X, 'constant'); Y=detrend(Y, 'constant');

  R=covf([X Y],numlags);

  PHI=zeros(2*numlags-1,numio^2);
  
  %PHI(:,i+(j-1)*numio)=E[z(i,:)*z(j,:)]  This is a 2-sided correlation  
  for i=1:numio
     for j=1:numio
	    PHI(:,i+(j-1)*numio)=[R(j+(i-1)*numio,numlags:-1:2)';
		                      R(i+(j-1)*numio,:)'];
	 end
  end

  if numsides == 1
    Nxxr=numlags:2*numlags-1;
    Nxxc=numlags:-1:1;
	Nxy=numlags:2*numlags-1;
   else
    Nxxr=numlags:2*numlags-2;
    Nxxc=numlags:-1:2;
	Nxy=numlags/2+1:3*numlags/2 -1;
	numlags=numlags-1;
  end

%Solve matrix equations to identify filters

%NOTE: this solution to the matrix equations  works, but may not be 
%      the most efficient solution available because the toeplitz
%      organization of the submatrices is not exploited.  This could
%      be further investigated by an ambitious researcher.

PX=zeros(cX*numlags,cX*numlags);
for i=1:cX
	for j=1:cX
        cidx=1+(i-1)*numlags:i*numlags;
        ridx=1+(j-1)*numlags:j*numlags;
        PX(ridx,cidx)=toeplitz(PHI(Nxxc,i+(j-1)*numio),PHI(Nxxr,i+(j-1)*numio));
    end
end

% disp('Determinant of PX')
% det(PX)

  
  PXY=zeros(cX*numlags,cY);
  for i=1:cX							%input loop
     for j=cX+1:cY+cX				    %output loop
	    ridx=1+(i-1)*numlags:i*numlags;
		cidx=j-cX;
	    PXY(ridx,cidx)=PHI(Nxy,i+(j-1)*numio);
      end
   end	

   H=fs*(PX\PXY);
   H(isnan(H)) = 0;
   %H=fs*(PX)^-1*PXY;
   
   
%Estimate of VAF for each input of each output based upon identified system
v=diag(100*(PXY'*H)./cov(Y)/fs);
mcc=sum(v.*diag(cov(Y)))/sum(diag(cov(Y)));

%first weight for offsets to account for detrending
mxyh = zeros(cY,1);
for i = 1:cX
    for o = 1:cY
        mxyh(o) = mxyh(o) + repmat(mx(i),1,numlags)*H(1+(i-1)*numlags:i*numlags,o);
    end
end

H = [-mxyh'+my; H];