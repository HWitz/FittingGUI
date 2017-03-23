function z=function_model_all_types2(p,w,formula)
z_comp = eval(formula);
z=[real(z_comp),imag(z_comp)];