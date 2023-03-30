function [REZ, sumNM] = set_rez(windL, T_p, A1)
    signal2 = padarray(A1, 5760, 'sym', 'both'); 
    Fs = 0.016; 
    fc = centfrq('coif2');
    freqrange = [0.000005 0.016]; 
    scalerange = fc./(freqrange*(1/Fs));
    scales = scalerange(end):1:scalerange(1); 
    Coeffs = cwt(signal2, scales, 'coif2'); 
    Coeffs = Coeffs'; 
    coefftest = Coeffs(5760 : length(signal2) - 5760, :); 
    coefftest = coefftest'; 
    for q = 1 : length(scales) 
        for i = 1 : length(A1)  
            m(1, i) = coefftest(q, i);
        end 
        z = 1;
        while z <= length(A1) - windL   
            dSR = mean(m(z : z + windL - 1));  
            dMED = median(m(z : windL - 1 + z));
            sm = 0;
            for k = z : windL - 1 + z              
                sm = sm + (m(k) - dSR) * (m(k) - dSR);
            end
            St = sqrt((1 / windL) * sm);            
            Pad = T_p * St;             
            n = 1;
            dMOD = abs(abs(m(z + windL)) - dMED);      
            if dMOD > Pad               
                REZ(q, z) = m(z + windL);
            else
                REZ(q, z) = 0;
            end
        z = z + 1;
        end
    end
    sumNM = sum(REZ);
end