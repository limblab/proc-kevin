function X = MultinomialSelection(N,DPars,X0,XForce)
% DECODER FUNCTION: Decode velocity from neural signals using softmax.
%
% General Decoder Functions yntax:
% X = DecoderFcn(N,par1,par2,...,parN)
%
% Specific syntax:
% X = MultinomialSelection(N,DPars,X0)
% X = MultinomialSelection(N,DPars,X0,XForce)
%
% Inputs
% ------
% N:    Neural Signals
% Additional parameters:
% DPars:    Struct of decoder model parameters created by the ComputeKFDecoderPars
%           function from calibration data obtained during a task.
%           mnrModel:   function for multinomial regression: mnrModel(firingrate,A,b)
%           A:          Mapping parameter for mnrModel.
%           CatList:    Categories in mnrModel.
%           speedScale: How much to scale speeds defiend in CatList.
%           mixCat:     How much to blend each category 
%           dt:               Timestep.
% X0:   Current state vector, input from the Task Function. We are
%       expecting the second two states to be the velocity predictions
%       X0 = [x, y, vx, vy] for the 2D cursor.
% XForce:   (optional, true or false) If the XForce input is true, the
%       decoder will X = X0. For example, this is useful to force the Task
%       Function to recenter a cursor between trials.
%
%
% Outputs
% -------
% X: Updated state of controlled object
%
%
%
% ZC Danziger Jul 2022 
%


if isempty(DPars) || (nargin == 4 && XForce)
    % if we are not given any decoder parameters, or the user told us to
    % force the output to be X0 spit back the curent state
    X = X0;

else
    % compute category estimates
    estCats = DPars.mnrModel(N,DPars.A);
    
    % mix estimated categories according to their probabilities (including
    % some deadspace for predictions above or below mixCat)
    wCats = max(0,min(1, (estCats+DPars.mixCat-1)/(2*DPars.mixCat-1) ));
    wCats = wCats/sum(wCats);      % renormalize so all weights sum to 1

    % extract velocity predictions, weight them by wCats, then sum
%     Vp = sum( vertcat(DPars.CatList{:,2}).*wCats, 1)';
%     Vp = cell2mat(DPars.CatList(:,2))'*wCats;
    Vp = wCats' * cell2mat(DPars.CatList(:,2));

    % integrate to find the next cursor state
    X(1:2) = X0(1:2) + DPars.dt*Vp;
    X(3:4) = Vp;

end


% in all cases, do not predict a position outside the workspace [-1 1]

% changed to 50,-50 for our screen (KLB). Could also just have a
% multiplier to adjust some sort of gain, but whatever.
X(1:2) = max(-20,min(20,X(1:2)));






