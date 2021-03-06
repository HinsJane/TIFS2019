function [ D ] = Dcalnew( V, W0, Wi, Y, param )

    D = zeros(1, length(V));
    A = 2*param.theta;
    
    N = length(Y);
    for i = 1 : length(V)
%         disp(['chl of D :', num2str(i)]); 

        Vi = V{i};
        Wione = Wi(:,i);
        ViTWi = Vi'*Wione;

        Bmat = (Vi'*W0-Y')*(W0'*Vi-Y);
        B = N.^(-1)*trace(Bmat);
        
        Cmat = ViTWi*ViTWi';
        C = -N.^(-1)*trace(Cmat);
        
        E = -2*param.beta*norm(Wione).^2;
    

        eqn = [A B 0 C E];
        s = roots(eqn);
%         Dtsvl(i) = toc(Dsvl);


        k = 1;
        for j = 1 : length(s)
            if( real(s(j))>0  &&  (real(s(j))>imag(s(j))) )
                srl(k) = double(real(s(j)));
                k = k + 1;
            end
        end
        
        if (k == 1)
            disp('Warning: D is zero!');
        end
        
        Dout = zeros(1, length(srl));
        for k = 1 : length(srl)
%             disp(['D', num2str(k),'of chl', num2str(i),': ', num2str(srl(k)) ]);
            Dout(k) = Doneobjfun( V{i}, srl(k), W0, Wi(:,i), Y, param );
        end
        
        [output,I] = min(Dout);
        D(i) = srl(I);
        
        clear srl
        
    end
    D = D./norm(D);
end

