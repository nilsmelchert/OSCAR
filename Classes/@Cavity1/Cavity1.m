classdef Cavity1
    %Cavity1 the class used to define cavity with thin mirrors
    % To define a cavity use
    % C1 = Cavity1(I1,I2,L,E1) with C1 the cavity defined, I1 and I2 2
    % interfaces to represent the mirrors of the cavity, L to represents
    % the length of the cavity in m and E1 the input field (an instance of
    % the class E_field)
    
    properties
        I_input
        I_end
        
        Length
        Laser_in
        Laser_start_on_input = false;
        Resonance_phase = [];
        Cavity_scan_all_field = [];
        Cavity_scan_param = [1000 500 2E-9 1000]; % Number of points for the scan over one FSR, Number of points for the zoom, span of the zoom, max number of iteration (if the cavity is high finesse)
        Cavity_phase_param = 200;  % Number of iteration to find the resonance phase of the cavity, 100 is usually enough
        Cavity_scan_R = [];
        Cavity_scan_RZ = [];
        Cavity_EM_mat = [];
        
        Propagation_mat;     % Pre-compute the complex matrix used for the propagation
        
        Field_circ = [];
        Field_ref = [];
        Field_trans = [];
        Field_reso_guess = [];
        Loss_RTL = [];
        
    end
    
    methods
        function C = Cavity1(varargin)
            switch nargin
                case{0,1,2,3}
                    error('Cavity1(): at least 4 arguments must be given: 2 interfaces, a length and the input laser beam')
                case 4
                    if  ~(isa(varargin{1}, 'Interface') || isa(varargin{1}, 'Mirror'))
                        error('Cavity1(): the first argument must be an instance of the class Interface or Mirror')
                    end
                    
                    if  ~(isa(varargin{2}, 'Interface') || isa(varargin{2}, 'Mirror'))
                        error('Cavity1(): the second argument must be an instance of the class Interface or Mirror')
                    end
                    
                    if  (~isreal(varargin{3})) && (varargin{3} <= 0)
                        error('Cavity1(): the third argument, length of the cavity must be a real positive number')
                    end
                    
                    if  ~isa(varargin{4}, 'E_Field')
                        error('Cavity1(): the fourth argument, the input laser beam must be an instance of the class E_field')
                    end
                    
                    
                    C.I_input = varargin{1};
                    C.I_end = varargin{2};
                    C.Length = varargin{3};
                    C.Laser_in = varargin{4};
                    
                    C.Propagation_mat = Prop_operator(C.Laser_in,C.Length);
                    
                otherwise
                    disp('Cavity1(): invalid number of input arguments, cavity not created')
                    
            end
        end
        
        function G = Grid(obj)
            G = obj.Laser_in.Grid;
        end
        
    end
    
end
