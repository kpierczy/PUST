function MinimalWorkingExample()

    initSerialControl COM3 % initialise com port
    Y = [];
    U = [];
    k = 0;
    
    while(1)
        % obtaining measurements
        measurements = readMeasurements([1,3]); % read measurements 1 and 3
        
        % processing of the measurements and new control values calculation
        disp(measurements); % process measurements
      
        % sending new values of control signals
        if(    k <  10)
            controls = [ 100,   0];
        elseif(k <  50)
            controls = [ 100, 100];
        elseif(k < 100)
            controls = [  20,  20];
        else
            controls = [  25,  15];
        end
        % send new corresponding control values for elements 5 and 6
        sendControls([5,6], controls); 
        k = k+1;
        
        Y = [Y; measurements]; subplot(2,1,1); plot(Y); drawnow
        U = [U; controls];     subplot(2,1,2); stairs(U); ylim([-5,105]); drawnow
        
        % synchronising with the control process
        % wait for new batch of measurements to be ready
        waitForNewIteration(); 
    end
end
