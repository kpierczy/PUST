%========================================================================
% File name   : PID.m
% Date        : 26th April 2020
% Version     : 1.0.0
% Author      : Krzysztof Pierczyk
% Description : Generic class implementing PID SISO regulator.Regulator 
%               is designed to minimize absolute error value and it
%               doesn't take into account direct informations about 
%               process' ouput ans setpoint.
%
%               PID is implemented in it's incremental variant.
%========================================================================
classdef PID < handle

    %====================================================================
    % Simple PID regulator implementation. 
    %====================================================================
    
    properties (Access = public, Dependent)
        
        % PID regulator's parameters
        K  (1, 1) double {mustBeReal}
        Ti (1, 1) double {mustBeReal}
        Td (1, 1) double {mustBeReal}
        Ts (1, 1) double {mustBeReal}
    
    end
    
    properties (Access = public)
        
        % PID output limits
        umin  (1, 1) double {mustBeReal} = -Inf
        umax  (1, 1) double {mustBeReal} =  Inf
        dumin (1, 1) double {mustBeReal} = -Inf
        dumax (1, 1) double {mustBeReal} =  Inf
        
        % @note : This class implements PID in its incremental shape
        %         (it computes CVs increases, not absolute values). 
        %         To minimize number of arguments passed to the 
        %         'compute()' method every iteration of controll loop,
        %         DMC class implements internal memory region to keep
        %         track of regulation history.
        %
        %         Following properties are public for cases when 
        %         regulation process is switched to manual for some
        %         period of time. When regulation is switched-back to
        %         automatic regulation, these parameters should be updated
        %         to ensure smooth start-up.
        
        % Previous CV value 
        uk_1 (1, 1) double {mustBeReal} = 0
        
        % Regulator's errors
        ek_1 (1, 1) double {mustBeReal} = 0
        ek_2 (1, 1) double {mustBeReal} = 0   
        
    end
    
    % Internal interface elements
    properties (Access = private)
        
        % PID regulator's parameters (internal copies)
        K_shadow  (1, 1) double {mustBeReal} = 0
        Ti_shadow (1, 1) double {mustBeReal} = Inf
        Td_shadow (1, 1) double {mustBeReal} = 0
        Ts_shadow (1, 1) double {mustBeReal} = 1
        
        % Inceremental PID's parameters
        r0 (1, 1) double {mustBeReal} = 0
        r1 (1, 1) double {mustBeReal} = 0
        r2 (1, 1) double {mustBeReal} = 0
     
    end
    
    %--------------------------------------------------------------------
    %-------------------------- Public methods --------------------------
    %--------------------------------------------------------------------
    
    methods (Access = public)
        
        %================================================================
        % PID regulator initialization
        % 
        % @param P, Ti, Td : PID parameters
        % @param Ts : sampling period
        %================================================================
        function obj = PID(K, Ti, Td, Ts)
            obj.K = K;
            obj.Ti = Ti;
            obj.Td = Td;
            obj.Ts = Ts;
        end
        
        %================================================================
        % Calculates PID regulator output based on the actual
        % error value (previous errors and controll values
        % are taken from PID's internal memory)
        %
        % @param ek : actual error
        %================================================================
        function u = compute(obj, ek)
            
            % Compute control value
            du = obj.r0*ek + obj.r1*obj.ek_1 + obj.r2*obj.ek_2;
            
            % Update previous errors values
            obj.ek_2 = obj.ek_1;
            obj.ek_1 = ek;
            
            % Apply dU value constraints
            if du > obj.dumax
                du = obj.dumax;
            elseif du < obj.dumin
                du = obj.dumin;
            end

            % Apply U value constraints
            if obj.uk_1 + du > obj.umax
                u = obj.Umax;
            elseif obj.uk_1 + du < obj.umin
                u = obj.umin;
            else
                u = obj.uk_1 + du;
            end
            
            % Update PID's memory
            obj.uk_1 = u;

        end
        
    end
    
    %--------------------------------------------------------------------
    %------------------------- Private methods --------------------------
    %--------------------------------------------------------------------
    
    methods (Access = private)
        
        %================================================================
        % Updates internal r0, r1, r2 values basing on actual values of
        % K, Ti, Td and Ts parameters.
        %================================================================
        function update(obj)
            obj.r0 = obj.K * ( 1 + obj.Ts / (2 * obj.Ti) + obj.Td / obj.Ts);
            obj.r1 = obj.K * ( obj.Ts / (2 * obj.Ti) - 2 * obj.Td / obj.Ts - 1);
            obj.r2 = obj.K * obj.Td / obj.Ts;
        end
        
    end
    
    %--------------------------------------------------------------------
    %------------------------ Getters & setters -------------------------
    %--------------------------------------------------------------------
    
    methods
       
        %================================================================
        % Block of getters & setters used to remove the need of explicit
        % incremental PID' parameters calculation.
        %================================================================
        
        function val = get.K(obj)
            val = obj.K_shadow;
        end
        function set.K(obj, K)
            obj.K_shadow = K;
            obj.update();
        end
        
        function val = get.Ti(obj)
            val = obj.Ti_shadow;
        end
        function set.Ti(obj, Ti)
            obj.Ti_shadow = Ti;
            obj.update();
        end
        
        function val = get.Td(obj)
            val = obj.Td_shadow;
        end
        function set.Td(obj, Td)
            obj.Td_shadow = Td;
            obj.update();
        end
        
        function val = get.Ts(obj)
            val = obj.Ts_shadow;
        end
        function set.Ts(obj, Ts)
            obj.Ts_shadow = Ts;
            obj.update();
        end
        
    end
end

