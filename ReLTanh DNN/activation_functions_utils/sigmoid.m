% =========================================================================
%                          Written by Xin Wang and Yi Qin
% =========================================================================
function X = sigmoid(P)
    X = 1./(1+exp(-P));
end