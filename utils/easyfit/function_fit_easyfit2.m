function [pbest,fval,exitflag,output]=function_fit_easyfit2(x,y,pinit,fhandle,LB,UB,options,formula)
% pbest=easyfit(x,y,pinit,fhandle,LB,UB,options)
% the argument OPTIONS is ... optional
% X     the input of the model-function which parameters P has to be fitted.
%       X has to be column(s) wise vector or matrix.
%
% Y     the experimental data which would be modeled by the model-function.
%
% PINIT vector of starting parameters.
%
% FHANDLE   the function handle defining the model-function, example: fhandle=@myfunction.
%           When complex values are involved in the model, the function has to return
%           a 2-columns wise matrix which contains real and imaginary parts. An
%           example is given below.
%
%  LB - lower bound vector or array, must be the same size as x0
%       If no lower bounds exist for one of the variables, then
%       supply -inf for that variable.
%       If no lower bounds at all, then LB may be left empty.
%
%  UB - upper bound vector or array, must be the same size as x0
%       If no upper bounds exist for one of the variables, then
%       supply +inf for that variable.
%       If no upper bounds at all, then UB may be left empty.
%
% OPTIONS   are to be set when for instance, function values are
%           typically lower than 10^-4. See OPTIMSET in the MATLAB help.
%
% PBEST     "best" parameters resulting from the fit process.
% 
%  See fminsearch for all other arguments.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%april 2006
%jean-luc.dellis@u-picardie.fr
%may 2006
%Special thanks to John D'Errico who created FMINSEARCHBND which allows to set bounds
%to the parameters values, see :
%http://www.mathworks.com/matlabcentral/fileexchange
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EXAMPLE 1: R ==> R fitting
%% Paste these 2 functions (easyfit_demo_1 and myfun) in the same m-file
%% then launchs easyfit_demo_1 from the command window
%
% function pbest=easyfit_demo_1
% x=[-3:0.2:3]';                                          % column vector
% pexp=[1,1];                                             % slope: 1, intercept: 1
% yexp=myfun(pexp,x);                                     % creates data with p=[1,1]
% 
% fhandle=@myfun;                                         % handle of the model-function
% LB=[1.1,0];                                             % Lower Bounds
% UB=[2,0.5];                                             % Upper Bounds
%                                                         % NOTE that (for demonstration purpose) the
%                                                         % BOUNDS DO NOT contain the right values.
%                                                         % So, one expects BAD RESULTS. 
% pinit=[2,5];                                            % starting parameters                                                        
% pbest=easyfit(x,yexp,pinit,fhandle,LB,UB);              % search best parameters with BAD bounds
% plot(x,yexp,'-*k',x,fhandle(pinit,x),'.',...
%     x,fhandle(pbest,x),'or')                            % compare data in a graph           
% legend('experimental','initial guess','best, inside the bad bounds',...
%     'location','best')
% grid on
% 
% function y=myfun(p,x)                                   % simple straight line
% y=p(1)*x+p(2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EXAMPLE 2: R ==> R^2 fitting, Application to Impedance Spectroscopy
%% Paste these 2 functions (demo_12_easyfit and model) in the same m-file
%% then launchs demo_12_easyfit from the command window
%
% function p=demo_12_easyfit
%           % demo for the use of easyfit applied to impedance spectroscopy
%           % note that the impedance of a Constant Phase Element
%           % is characterized by 2 parameters A and a: Z = A * (jw)^a
%         
% w=2*pi*logspace(1,6)';                        % vector pulsation
% p=[1e5,2e-9,1/1e-7,-0.7];                     % parameters for experimental-data construction
% z=model(p,w);                                 % the function "model" is given below                                 
%                                               
% z(:,1)=z(:,1).*(1+0.05*randn(size(z(:,1))));  % 1irst colunm = real part plus noise
% z(:,2)=z(:,2).*(1+0.05*randn(size(z(:,2))));  % 2econd column = imaginary part plus noise
% % assume that a raw graphical simulation gives these starting parameters for fitting:
% pinit=[0.5e5,1e-9,1/2e-7,-1];
% % launch easyfit and get the best parameters:
% pbest=easyfit(w,[z(:,1),z(:,2)],pinit,@model,[],[]);
% % now, lets graphically compare in the complex plane, best, exp and init impedances:
% zbest=model(pbest,w);
% zinit=model(pinit,w);
% plot(z(:,1),-z(:,2),'ob',zbest(:,1),-zbest(:,2),'-*r',zinit(:,1),-zinit(:,2),'.k')
% axis equal
% legend('Zexp','Zbest','Zinit','location','best')
% xlabel('Real (Z)')
% ylabel('- Imaginary (Z)')
%  
% function z=model(p,w)
% % model = RC in parallel + a CPE (Constant Phase Angle) in series
% z1=p(1);                                      % the resistor (impedance)
% y2=j*p(2)*w;                                  % the capacitor(admittance)
% z3=p(3)*(j*w).^p(4);                          % the CPE impedance
% y1=1./z1;                                     % the R admittance
% y=y1+y2;                                      % the R // C admittance
% zthe=1./y+z3;                                 % the R // C + E impedance
% z=[real(zthe),imag(zthe)];                    % split Real and Imaginary parts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EXAMPLE 3: R^2 ==> R^3 fitting
%% Paste these 2 functions (demo_23_easyfit and testfun23) in the same m-file
%% then launchs demo_23_easyfit from the command window
%
% function pbest=demo_23_easyfit
% x=[1:0.2:10]';                                % 1-column vector
% x=[x,rand(size(x))];                          % 2-columns matrix
% y=testfun23([1,1],x);                         % y = 3-columns matrix
% pbest=easyfit(x,y,[2,5],@testfun23,[],[]);    % search best parameters
%                                               % with starting parameters [2,5]
% 
% function y=testfun23(p,x)
% a=p(1)*x(:,1).^2+p(2)*x(:,2);
% b=p(1)*x(:,1).*x(:,2)+p(2);
% c=-p(1)*x(:,1).^3+p(2);
% y=[a,b,c];


%% Makes formula to 
nparam=length(pinit);
if nargin<7,options=[];end
		[pbest,fval,exitflag,output]=fminsearchbnd(@distance,pinit,LB,UB,options);
            function dist=distance(pinit)       % DISTANCE is "nested" so, it "knows" x,y and fhandle
                ymod=fhandle(pinit,x,formula);
            dist=sum(sum((ymod-y).^2));         % general form
            %dist=sum(sum(((ymod-y)./y).^2));   % sometimes used in Z spectroscopy (proportionnal weigthing)   
            end
end
 %****************************************************************************
% Here is the FMINSEARCHBND function created by John D'Errico
% Sub-functions have been nested. This may cause crashes when used with old
% versions of MATLAB
% FMINSEARCHBND may be saved in a separate file
function [x,fval,exitflag,output]=fminsearchbnd(fun,x0,LB,UB,options,varargin)
% fminsearchbnd: fminsearch, but with bound constraints by transformation
% usage: fminsearchbnd(fun,x0,LB,UB,options,p1,p2,...)
% 
% arguments:
%  LB - lower bound vector or array, must be the same size as x0
%
%       If no lower bounds exist for one of the variables, then
%       supply -inf for that variable.
%
%       If no lower bounds at all, then LB may be left empty.
%
%  UB - upper bound vector or array, must be the same size as x0
%
%       If no upper bounds exist for one of the variables, then
%       supply +inf for that variable.
%
%       If no upper bounds at all, then UB may be left empty.
%
%  See fminsearch for all other arguments and options.
%  Note that TolX will apply to the transformed variables. All other
%  fminsearch parameters are unaffected.
%
% Notes:
%
%  Variables which are constrained by both a lower and an upper
%  bound will use a sin transformation. Those constrained by
%  only a lower or an upper bound will use a quadratic
%  transformation, and unconstrained variables will be left alone.
%
%  Variables may be fixed by setting their respective bounds equal.
%  In this case, the problem will be reduced in size for fminsearch.
%
%  The bounds are inclusive inequalities, which admit the
%  boundary values themselves, but will not permit ANY function
%  evaluations outside the bounds.
%
%
% Example usage:
% rosen = @(x) (1-x(1)).^2 + 105*(x(2)-x(1).^2).^2;
%
% fminsearch(rosen,[3 3])     % unconstrained
% ans =
%    1.0000    1.0000
%
% fminsearchbnd(rosen,[3 3],[2 2],[])     % constrained
% ans =
%    2.0000    4.0000

% size checks
xsize = size(x0);
x0 = x0(:);
n=length(x0);

if (nargin<3) || isempty(LB)
  LB = repmat(-inf,n,1);
else
  LB = LB(:);
end
if (nargin<4) || isempty(UB)
  UB = repmat(inf,n,1);
else
  UB = UB(:);
end

if (n~=length(LB)) | (n~=length(UB))
  error 'x0 is incompatible in size with either LB or UB.'
end

% set default options if necessary
if (nargin<5)|isempty(options)
  options = optimset('fminsearch');
end

% stuff into a struct to pass around
params.args = varargin;
params.LB = LB;
params.UB = UB;
params.fun = fun;
params.n = n;

% 0 --> unconstrained variable
% 1 --> lower bound only
% 2 --> upper bound only
% 3 --> dual finite bounds
% 4 --> fixed variable
params.BoundClass = zeros(n,1);
for i=1:n
  k = isfinite(LB(i)) + 2*isfinite(UB(i));
  params.BoundClass(i) = k;
  if (k==3) & (LB(i)==UB(i))
    params.BoundClass(i) = 4;
  end
end

% transform starting values into their unconstrained
% surrogates. Check for infeasible starting guesses.
x0u = x0;
k=1;
for i = 1:n
  switch params.BoundClass(i)
    case 1
      % lower bound only
      if x0(i)<=LB(i)
        % infeasible starting value. Use bound.
        x0u(k) = 0;
      else
        x0u(k) = sqrt(x0(i) - LB(i));
      end
      
      % increment k
      k=k+1;
    case 2
      % upper bound only
      if x0(i)>=UB(i)
        % infeasible starting value. use bound.
        x0u(k) = 0;
      else
        x0u(k) = sqrt(UB(i) - x0(i));
      end
      
      % increment k
      k=k+1;
    case 3
      % lower and upper bounds
      if x0(i)<=LB(i)
        % infeasible starting value
        x0u(k) = -pi/2;
      elseif x0(i)>=UB(i)
        % infeasible starting value
        x0u(k) = pi/2;
      else
        x0u(k) = 2*(x0(i) - LB(i))/(UB(i)-LB(i)) - 1;
        % shift by 2*pi to avoid problems at zero in fminsearch
        % otherwise, the initial simplex is vanishingly small
        x0u(k) = 2*pi+asin(max(-1,min(1,x0u(k))));
      end
      
      % increment k
      k=k+1;
    case 0
      % unconstrained variable. x0u(i) is set.
      x0u(k) = x0(i);
      
      % increment k
      k=k+1;
    case 4
      % fixed variable. drop it before fminsearch sees it.
      % k is not incremented for this variable.
  end
  
end
% if any of the unknowns were fixed, then we need to shorten
% x0u now.
if k<=n
  x0u(k:n) = [];
end

% were all the variables fixed?
if isempty(x0u)
  % All variables were fixed. quit immediately, setting the
  % appropriate parameters, then return.
  
  % undo the variable transformations into the original space
  x = xtransform(x0u,params);
  
  % final reshape
  x = reshape(x,xsize);
  
  % stuff fval with the final value
  fval = feval(params.fun,x,params.args{:});
  
  % fminsearchbnd was not called
  exitflag = 0;
  
  output.iterations = 0;
  output.funcount = 1;
  output.algorithm = 'fminsearch';
  output.message = 'All variables were held fixed by the applied bounds';
  
  % return with no call at all to fminsearch
  return
end

% now we can call fminsearch, but with our own
% intra-objective function.
% [xu,fval,exitflag,output] = fminsearch_breakable(@intrafun,x0u,options,params);
 [xu,fval,exitflag,output] = fminsearch(@intrafun,x0u,options,params);  %hwi 12.12.2016: wieder auf Matlab-Routine geändert aus Urheberrechtsgründen

% undo the variable transformations into the original space
x = xtransform(xu,params);

% final reshape
x = reshape(x,xsize);

% ======================================
% ========= begin subfunctions =========
% ======================================
function fval = intrafun(x,params);
% transform variables, then call original function

% transform
xtrans = xtransform(x,params);

% and call fun
fval = feval(params.fun,xtrans,params.args{:});
end

% ======================================
function xtrans = xtransform(x,params);
% converts unconstrained variables into their original domains

xtrans = zeros(1,params.n);
% k allows soem variables to be fixed, thus dropped from the
% optimization.
k=1;
for i = 1:params.n
  switch params.BoundClass(i)
    case 1
      % lower bound only
      xtrans(i) = params.LB(i) + x(k).^2;
      
      k=k+1;
    case 2
      % upper bound only
      xtrans(i) = params.UB(i) - x(k).^2;
      
      k=k+1;
    case 3
      % lower and upper bounds
      xtrans(i) = (sin(x(k))+1)/2;
      xtrans(i) = xtrans(i)*(params.UB(i) - params.LB(i)) + params.LB(i);
      % just in case of any floating point problems
      xtrans(i) = max(params.LB(i),min(params.UB(i),xtrans(i)));
      
      k=k+1;
    case 4
      % fixed variable, bounds are equal, set it at either bound
      xtrans(i) = params.LB(i);
    case 0
      % unconstrained variable.
      xtrans(i) = x(k);
      
      k=k+1;
  end
end
end
end
