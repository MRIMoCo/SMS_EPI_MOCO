function res = SENSE_SMS(input,sens,R) 
%input: aliasing SMS image [nx, ny, nc]
%sens: coil sensitivity for the slices of sms. [nx, ny, nc, R]
%R: acceleration factor for SMS scan
%Author: Bo Li 11-10-2020
    [Nx,Ny,Nc] = size(input);
    res = zeros(Nx,Ny,R);
    sens_sms=zeros(R,Nc);
    % loop over the top-1/R of the image
    for x = 1:Nx
        % loop over the entire left-right extent
        for y = 1:Ny
            
%             if (x==41)&&(y==24)&&(imgIndex(1)==5)&&(imgIndex(2)==12)
%                 aaa=1;
%             end
            
            % pick out the sub-problem sensitivities
            for iR=1:R
                sens_sms(iR,:)=sens(x,y,:,iR);
            end
            tmp_S = transpose(sens_sms);%(reshape(sens(x_idx,y,1,:),R,[]));
            %' is conj and transpose
            S = tmp_S'*tmp_S;
            % solve the sub-problem in the least-squares sense
            out = pinv(S)*(tmp_S'*reshape(input(x,y,:),[],1));
            for iR=1:R
                res(x,y,iR)=out(iR,1);
            end
        end
    end
    
end