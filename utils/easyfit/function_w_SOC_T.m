function z=function_w_SOC_T(p,w,formula)
T = formula.Temperatur;
SOC = formula.SOC;
z_comp = eval(formula.string);
z=[real(z_comp),imag(z_comp)];