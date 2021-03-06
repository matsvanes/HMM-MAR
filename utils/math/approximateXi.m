function Xi = approximateXi(Gamma,T,hmm)
[~,order] = formorders(hmm.train.order,hmm.train.orderoffset,...
    hmm.train.timelag,hmm.train.exptimelag);
K = size(Gamma,2);
additiveHMM = hmm.train.additiveHMM;
if additiveHMM
    Xi = zeros(sum(T-1-order),K,2,2);
    for j = 1:length(T)
        indG = (1:(T(j)-order)) + sum(T(1:j-1)) - (j-1)*order;
        indXi =  (1:(T(j)-order-1)) + sum(T(1:j-1)) - (j-1)*(order+1);
        for t = 1:length(indXi)
            for k = 1:K
                g = [Gamma(indG(t),k) (1-Gamma(indG(t),k))];
                xi = g' * g; xi = xi / sum(xi(:));
                Xi(indXi(t),k,:,:) = xi;
            end
        end
    end
else
    Xi = zeros(sum(T-1-order),K,K);
    for j = 1:length(T)
        indG = (1:(T(j)-order)) + sum(T(1:j-1)) - (j-1)*order;
        indXi =  (1:(T(j)-order-1)) + sum(T(1:j-1)) - (j-1)*(order+1);
        for t = 1:length(indXi)
            xi = Gamma(indG(t),:)' * Gamma(indG(t+1),:);
            xi = xi / sum(xi(:));
            Xi(indXi(t),:,:) = xi;
        end
    end
end
end