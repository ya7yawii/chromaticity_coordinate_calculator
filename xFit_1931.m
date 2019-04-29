function int = xFit_1931(wave)
t1 = 0.0624.*(1-heaviside(wave-442.0))+0.0374.*heaviside(wave-442.0);
t2 = 0.0264.*(1-heaviside(wave-599.8))+0.0323.*heaviside(wave-599.8);
t3 = 0.0490.*(1-heaviside(wave-501.1))+0.0382.*heaviside(wave-501.1);
int = 0.362.*exp(-0.5.*((wave-442.0).*t1).^2)+1.056.*exp(-0.5.*((wave-599.8).*t2).^2)-0.065.*exp(-0.5.*((wave-501.1).*t3).^2);
end
