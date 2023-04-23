function [matrix] = wavelet_transform(F, L, T_p)
    signal = padarray(F, 5760, 'sym', 'both'); 
    Fs = 0.016; 
    fc = centfrq('coif2');
    freqrange = [0.000005 0.016]; 
    scalerange = fc./(freqrange*(1/Fs));
    scales = scalerange(end):1:scalerange(1); 
    Coeffs = cwt(signal, scales, 'coif2'); 
    Coeffs = Coeffs'; 
    coefftest = Coeffs(5760 : length(signal) - 5760, :); 
    coefftest = coefftest'; 
    for q = 1 : length(scales) 
        for i = 1 : length(F)  
            m(1, i) = coefftest(q, i);
        end 
        z = 1;
        while z <= length(F) - L   
            dSR = mean(m(z : z + L - 1));  
            dMED = median(m(z : L - 1 + z));
            sm = 0;
            for k = z : L - 1 + z              
                sm = sm + (m(k) - dSR) * (m(k) - dSR);
            end
            St = sqrt((1 / L) * sm);            
            Pad = T_p * St;             
            n = 1;
            dMOD = abs(abs(m(z + L)) - dMED);      
            if dMOD > Pad               
                matrix(q, z) = m(z + L);
            else
                matrix(q, z) = 0;
            end
        z = z + 1;
        end
    end
end