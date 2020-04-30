function [x, P] = nonLinKFprediction(x, P, f, Q, type)
%NONLINKFPREDICTION calculates mean and covariance of predicted state
%   density using a non-linear Gaussian model.
%
%Input:
%   x           [n x 1] Prior mean
%   P           [n x n] Prior covariance
%   f           Motion model function handle
%               [fx,Fx]=f(x) 
%               Takes as input x (state), 
%               Returns fx and Fx, motion model and Jacobian evaluated at x
%               All other model parameters, such as sample time T,
%               must be included in the function
%   Q           [n x n] Process noise covariance
%   type        String that specifies the type of non-linear filter
%
%Output:
%   x           [n x 1] predicted state mean
%   P           [n x n] predicted state covariance
%

% Prediction
%[fx, Fx] = f(x);
n = size(x,1);
switch type
    case 'EKF'
        
        % 1. Predict state using non linear function
        % 2. Estimate the gaussian covariance using a linearization
        % Note: The acctual distrubution is not gaussian but we approximate 
        %       to a gaussian to simplify.
        [fx, Fx] = f(x);
        x = fx;
        P = Fx*P*Fx'+ Q;

       
        
    case 'UKF'
        % Make sure the covariance matrix is semi-definite
        if min(eig(P))<=0
            [v,e] = eig(P, 'vector');
            e(e<0) = 1e-4;
            P = v*diag(e)/v;
        end
       
        % 1. Get sigma points
        % 2. Transform SP using non linear transform
        % 3. Calculate estimated mean using transformed SP
        % 4. Calculate estimated covar using transformed SP and mean
        
        [SP,W] = signaPoints(x, P, 'UKF');
        [fx, Fx] = f(SP); %Transform
        
        x = 0;
        for i = 1:(2*n+1)
            x = x + W(i).*fx;
        end
        
        P = zeros(n,n);
        for i = 1:(2*n+1)
            P = P + W(i).* ((SP(:,i)-x)*(SP(:,i)-x)');
        end
            
    case 'CKF'
        
        % 1. Get sigma points
        % 2. Transform SP using non linear transform
        % 3. Calculate estimated mean using transformed SP
        % 4. Calculate estimated covar using transformed SP and mean
        
        [SP,W] = signaPoints(x, P, 'UKF');
        [fx, Fx] = f(SP); %Transform
        
        x = 0;
        for i = 1:(2*n)
            x = x + W(i).*fx;
        end
        
        P = zeros(n,n);
        for i = 1:(2*n)
            P = P + W(i).* ((SP(:,i)-x)*(SP(:,i)-x)');
        end
        
    otherwise
        error('Incorrect type of non-linear Kalman filter')
end

end