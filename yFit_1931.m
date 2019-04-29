function int = yFit_1931(wave)
t1 = 0.0213.*(1-heaviside(wave-568.8))+0.0247.*heaviside(wave-568.8);
t2 = 0.0613.*(1-heaviside(wave-530.9))+0.0322.*heaviside(wave-530.9);
int = 0.821.*exp(-0.5.*((wave-568.8).*t1).^2)+0.286.*exp(-0.5.*((wave-530.9).*t2).^2);
end
