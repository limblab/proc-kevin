function DS_spikes = DuplicateAndShift(spikes,numlags)
    % ok, here is how H is organized:
    %
    % H = [h11t0  h12t0  . h1Mt0  
    %      h11t-1 h12t-1 . h1Mt-1 
    %        .      .    .   .
    %      h11t-L h12t-L . h1Mt-L 
    %      h21t0  h22t0  . h2Mt0  
    %        .      .    .   .
    %      hN1t-L hN2t-L . hNMt-L]
    %
    % So it is arranged in columns, where the weights for each neurons
    % are stacked one onto each other. Each column corresponds to the
    % weights by which all the Inputs (e.g. neurons, N) transform in one particular
    % Output (e.g. muscle, M).
    % Weights for each neuron form a stack within each column (e.g. h11t0 to h11t-L)
    % which length depends on how far back in time we look at the Inputs
    % to make predictions. These subcolumns are organized such that the first (top) element
    % correspond to the weights at time = 0 history (now) and the bottom to the oldest time bin
    % 
    % That means that when we duplicate and shifts, the original N Inputs duration T
    % I = [i11 i21 . iN1
    %      i12 i22 . iN2
    %       .   .  .  .
    %      i1T i2T . iNT]
    %
    % (size TxN) have to end up looking like this (sizeTxN*T)
    %
    % I = [i11   zeros(1,L-1)    i21   zeros(1,L-1)  .
    %      i12 i11 zeros(1,L-2)  i21 i22 zeros(1,L-2).
    %      i1T i1T-1 . i1T-(L-1) i2T i2T-1 .  iNT-(L-1)]
    %

    [numpts,Nin] = size(spikes);
    DS_spikes = zeros(numpts,Nin*numlags);
    

    for i = 1:Nin*numlags
        n = ceil(i/numlags);
        lag = mod(i-1,numlags);
        prepend = zeros(lag,1);
        DS_spikes(:,i) = [prepend; spikes(1:end-lag,n)];
    end

end