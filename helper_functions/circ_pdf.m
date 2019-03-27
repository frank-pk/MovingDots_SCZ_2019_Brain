function y = circ_pdf(x, thetahat, kappa)

if nargin<1
    error('stats:normpdf:TooFewInputs','Input argument X is undefined.');
end
if nargin < 2
    thetahat = 0;
end
if nargin < 3
    kappa = 1;
end

% Return NaN for out of range parameters.
kappa(kappa <= 0) = NaN;

try
    y = exp(kappa.*cos(x-thetahat))./(2*pi.*bessi0(kappa));   
catch
    error('stats:normpdf:InputSizeMismatch',...
          'Non-scalar arguments must match in size.');
end
