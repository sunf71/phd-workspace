weights_step=0.05;

weights=normalize(rand(1,4));   % some start values
max_score=0;

Ntest=(length(weights))*2;      % number of new weights settings which are tested in each iteration

change_flag=1;
while(change_flag)  
    change_flag=0;
    new_weights=zeros(Ntest,length(weights));    
    new_scores=zeros(Ntest,1);
     
    for ii=1:(length(weights))
        weightsT=weights;
        if(weightsT(ii)+weights_step<1)
            weightsT(ii)=weightsT(ii)+weights_step;       
            weightsT=normalize(weightsT);        
            
            %new_score=run_some_function(weightsT);  % replace this
                                                     % function with your function which
                                                     % returns AP for this weight setting
            new_score=2-sum(abs(weightsT-[0.1 0.4 0.2 0.3]));  % remove this

            new_weights( (ii-1)*2 + 1,:)=weightsT;
            new_scores( (ii-1)*2+1 ) = new_score;
        end                
        weightsT=weights;
        if(weightsT(ii)-weights_step>=0)
            weightsT(ii)=weightsT(ii)-weights_step;
            weightsT=normalize(weightsT);    
            
            %new_score=run_some_function(weightsT);  % replace this
                                                     % function with your function which
                                                     % returns AP for this weight setting
            new_score=2-sum(abs(weightsT-[0.1 0.4 0.2 0.3])); % remove this function

            new_weights( (ii-1)*2 + 2,:)=weightsT;
            new_scores( (ii-1)*2+2 ) = new_score;                
        end
    end
    % check if max score is larger than previous score
    [max1,max2]=max(new_scores);
    if(max1>max_score)
        max_score=max1;
        weights=new_weights(max2,:);
        fprintf(1,'The new weights and score are\n');
        [weights max_score]
        change_flag=1;
        pause
    end    
end
