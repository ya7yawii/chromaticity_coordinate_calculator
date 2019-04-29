function int = zFit_1931(wave)
t1 = 0.0845.*(1-heaviside(wave-437.0))+0.0278.*heaviside(wave-437.0);
t2 = 0.0385.*(1-heaviside(wave-459.0))+0.0725.*heaviside(wave-459.0);
int = 1.217.*exp(-0.5.*((wave-437.0).*t1).^2)+0.681.*exp(-0.5.*((wave-459.0).*t2).^2);
end
